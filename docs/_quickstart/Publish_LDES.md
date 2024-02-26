---
title: Publish an LDES
parent: Quick start
layout: home
sort: 0
---

# Publish an LDES

This example focuses on both publishing and consuming a [Linked Data Event Stream](https://semiceu.github.io/LinkedDataEventStreams/) (LDES). We start by explaining how to setup an LDES server and publish data as an LDES, followed by the setup of the LDES client to replicate an LDES. In this example, the data examples are described with [OSLO](https://data.vlaanderen.be/) (the Flemish Interoperability Program) ontologies.

{: .note }
In this example we will show you that it is possible to publish multiple different types of LDES'es with one LDES server; an LDES with observations and an LDES with Mobility Hindrance.

<a href="https://github.com/Informatievlaanderen/VSDS-Tech-Docs/tree/main/docs/files/quickstart" download>
The files you will use for this quick start guide are here available
</a>
<br>
<br>

{: .note }
This quick start example demonstrates only a small amount of the capabilities of the LDES Server. For more information about the LDES server, please consult the [Configuring a new Event Stream](https://informatievlaanderen.github.io/VSDS-LDESServer4J/configuration/event-stream) in the [LDES Server Manual](https://informatievlaanderen.github.io/VSDS-LDESServer4J/).

## Before starting

1.  Make sure [Docker](https://docker.com/) has been installed on your device.
2.  Local Ports _8080_, and _27017_ are accessible.
3.  The command script is written in [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) code. Please modify it accordingly.

## Setup an LDES Server

To start a default LDES Server, a few basic steps are needed.

- Create a `ldes-server.yml` config file with this basic content

  ```yaml
  mongock:
    migration-scan-package: VSDS
  springdoc:
    swagger-ui:
      path: /v1/swagger
  ldes-server:
    host-name: "http://localhost:8080"
  management:
    tracing:
      enabled: false
  spring:
    data:
      mongodb:
        database: ldes
        host: ldes-mongodb
        port: 27017
        auto-index-creation: true
  ```

- Create a local `docker-compose.yml` file with the content below.

  ```yaml
  version: "3.3"
  services:
    ldes-server:
      container_name: basic_ldes-server
      image: ldes/ldes-server:2.10.0-SNAPSHOT # you can safely change this to the latest 2.x.y version
      environment:
        - SPRING_CONFIG_LOCATION=/config/
      volumes:
        - ./ldes-server.yml:/config/application.yml:ro
      ports:
        - 8080:8080
      networks:
        - ldes
      depends_on:
        - ldes-mongodb
    ldes-mongodb:
      container_name: quick_start_ldes-mongodb
      image: mongo:6.0.4
      ports:
        - 27017:27017
      networks:
        - ldes
    ldio-workbench:
      container_name: basic_ldes-replication
      image: ldes/ldi-orchestrator:1.0.0-SNAPSHOT
      environment:
        - SPRING_CONFIG_NAME=application
        - SPRING_CONFIG_LOCATION=/config/
      volumes:
        - ./ldio.yml:/config/application.yml:ro
      ports:
        - ${LDIO_WORKBENCH_PORT:-8081}:8080
      networks:
        - ldes
      profiles:
        - delay-started
  networks:
    ldes:
      name: quick_start_network
  ```

- Run this command within the work directory of `.yml` file, to start the containers:

```bash
docker compose up -d
while ! docker logs $(docker ps -q -f "name=ldes-server$") 2> /dev/null | grep 'Started Application in' ; do sleep 1; done
```

{: .note}
Note that we start the containers as deamons and then wait for the LDES server to be available by checking every second that the container log file contains the magic string Started Application in. You could also simply start it with docker compose up and wait until you actually see this magic string, but then you need to open a new command shell to execute the commands in the next sections.


- The LDES Server is now available at port `8080` and accepts members via `HTTP POST` requests.
- We will now configure the LDES Server. (note that this part can also be done with the Swagger endpoint (`/v1/swagger`), where more detailed documentation is available)

- Let's set the DCAT metadata for the server by defining a title and a description:

```bash
curl -X 'POST' \
  'http://localhost:8080/admin/api/v1/dcat' \
  -H 'accept: text/plain' \
  -H 'Content-Type: text/turtle' \
  --data-raw '  @prefix dct:   <http://purl.org/dc/terms/> .
                 @prefix dcat:  <http://www.w3.org/ns/dcat#> .

                 [] a dcat:Catalog ;
                    dct:title "My LDES'\''es"@en ;
                    dct:description "All LDES'\''es from publiser X"@en .
        '
```

- Next, let's add a collection for our mobility hindrances. This will be used to replicate the dataset from GIPOD:

  - A collection name "mobility-hindrances"
  - Will process members of type "https://data.vlaanderen.be/ns/mobiliteit#Mobiliteitshinder"
  - Will have 2 views :
  - The first view provides a basic view using a paginated fragmention (this view is called `pagination`).
    - A time-based fragmented view. This will fragment the members based on their timebased property (this view is called `pagination`). This value is by default set to `http://www.w3.org/ns/prov#generatedAtTime`

  ```bash
  curl -X 'POST' \
  'http://localhost:8080/admin/api/v1/eventstreams' \
  -H 'accept: text/turtle' \
  -H 'Content-Type: text/turtle' \
  --data-raw '  @prefix ldes: <https://w3id.org/ldes#> .
                @prefix dcterms: <http://purl.org/dc/terms/> .
                @prefix tree: <https://w3id.org/tree#>.
                @prefix sh:   <http://www.w3.org/ns/shacl#> .
                @prefix server: <http://localhost:8080/> .
                @prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
                @prefix collection: <http://localhost:8080/mobility-hindrances/> .

                server:mobility-hindrances a ldes:EventStream ;
                    ldes:timestampPath dcterms:created ;
                    ldes:versionOfPath dcterms:isVersionOf ;
                    tree:shape collection:shape .

                collection:shape a sh:NodeShape ;
                    sh:targetClass <https://data.vlaanderen.be/ns/mobiliteit#Mobiliteitshinder> .
                

                collection:timebased tree:viewDescription [
                    tree:fragmentationStrategy ([
                      a tree:HierarchicalTimeBasedFragmentation ;
                      ldes:timestampPath dcterms:created 
                      tree:maxGranularity "day" ;
                      tree:fragmentationPath ldes:timestampPath ;
                      ]) ;
                      tree:pageSize "100"^^<http://www.w3.org/2001/XMLSchema#int> ;
                  ] .
              
                collection:pagination tree:viewDescription [
                    tree:fragmentationStrategy  () ;
                      tree:pageSize "100"^^<http://www.w3.org/2001/XMLSchema#int> ;
                  ] .

            '
  ```

- Let's add some DCAT metadata for this collection:

  - We define an English and Dutch title and description
  - We define the creator of the collection to be http://sample.org/company/MyDataOwner

  ```bash
  curl -X 'POST' \
  'http://localhost:8080/admin/api/v1/eventstreams/mobility-hindrances/dcat' \
  -H 'accept: */*' \
  -H 'Content-Type: text/turtle' \
  -d '  @prefix dcat: <http://www.w3.org/ns/dcat#> .
        @prefix dct: <http://purl.org/dc/terms/> .
          [] a dcat:Dataset ;
              dct:title "Mobility Hindrances Collection"@en ;
              dct:title "Mobiliteitshindernissen collectie"@nl ;
              dct:description "A collection containing mobility hindrances"@en ;
              dct:description "Een collectie met Mobiliteitshindernissen"@nl ;
              dct:creator <http://sample.org/company/MyDataOwner> ;'
  ```

- We'll now also set the DCAT metadata for the time-based view by defining a title and a description :

  ```bash
  curl -X 'POST' \
  'http://localhost:8080/admin/api/v1/eventstreams/mobility-hindrances/views/by-time/dcat' \
  -H 'accept: */*' \
  -H 'Content-Type: text/turtle' \
  -d '@prefix dct:   <http://purl.org/dc/terms/> .
      @prefix dcat:  <http://www.w3.org/ns/dcat#> .

      [] a dcat:DataService ;
      dct:title "My timebased view"@en ;
      dct:description "Timebased fragmentation for the mobility-hindrances "@en .
      '
  ```

## Add mobility hindrance data to the LDES Server

Now we have shaped the LDES structure it is possible to add data to this Linked Data Event Stream. 

- Create a `mobility-hindrance.ttl` file with the following content:

  ```turtle
  <https://private-api.gipod.vlaanderen.be/api/v1/taxonomies/zonetypes/0fb72ef7-6ac9-4a70-b295-a30ea215d250>
          <http://www.w3.org/2004/02/skos/core#prefLabel>
                  "HinderZone"@nl-BE .

  <https://private-api.gipod.vlaanderen.be/api/v1/mobility-hindrances/10590495/973>
          a       <https://data.vlaanderen.be/ns/mobiliteit#Mobiliteitshinder> ;
          <http://purl.org/dc/elements/1.1/contributor>
                  [ a       <http://www.w3.org/ns/org#Organization> ;
                    <http://purl.org/dc/terms/isVersionOf>
                            <https://private-api.gipod.vlaanderen.be/api/v1/organisations/94204bd6-a6e5-0207-b722-643889e41d15> ;
                    <http://www.w3.org/2004/02/skos/core#prefLabel>
                            "Stad Ronse"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#langString>
                  ] ;
          <http://purl.org/dc/elements/1.1/creator>
                  [ a       <http://www.w3.org/ns/org#Organization> ;
                    <http://purl.org/dc/terms/isVersionOf>
                            <https://private-api.gipod.vlaanderen.be/api/v1/organisations/94204bd6-a6e5-0207-b722-643889e41d15> ;
                    <http://www.w3.org/2004/02/skos/core#prefLabel>
                            "Stad Ronse"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#langString>
                  ] ;
          <http://purl.org/dc/terms/created>
                  "2021-01-06T13:38:39.21Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> ;
          <http://purl.org/dc/terms/description>
                  "9600 Ronse - Pierre D'Hauwerstraat 5 - parkeerverbod"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#langString> ;
          <http://purl.org/dc/terms/isVersionOf>
                  <https://private-api.gipod.vlaanderen.be/api/v1/mobility-hindrances/10590495> ;
          <http://purl.org/dc/terms/modified>
                  "2021-01-06T13:39:23.79Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> ;
          <http://www.w3.org/ns/adms#identifier>
                  [ a       <http://www.w3.org/ns/adms#Identifier> ;
                    <http://www.w3.org/2004/02/skos/core#notation>
                            "10590495"^^<https://gipod.vlaanderen.be/ns/gipod#gipodId> ;
                    <http://www.w3.org/ns/adms#schemaAgency>
                            "https://gipod.vlaanderen.be"@nl-BE
                  ] ;
          <http://www.w3.org/ns/adms#versionNotes>
                  "MobilityHindranceWasImportedFromLegacy"@nl-BE ;
          <http://www.w3.org/ns/prov#generatedAtTime>
                  "2021-01-06T18:05:11.813Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> ;
          <https://data.vlaanderen.be/ns/mobiliteit#Inname.status>
                  <https://private-api.gipod.vlaanderen.be/api/v1/taxonomies/statuses/a411c53e-db33-436a-9bb9-d62d535b661d> ;
          <https://data.vlaanderen.be/ns/mobiliteit#beheerder>
                  [ a       <http://www.w3.org/ns/org#Organization> ;
                    <http://purl.org/dc/terms/isVersionOf>
                            <https://private-api.gipod.vlaanderen.be/api/v1/organisations/94204bd6-a6e5-0207-b722-643889e41d15> ;
                    <http://www.w3.org/2004/02/skos/core#prefLabel>
                            "Stad Ronse"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#langString>
                  ] ;
          <https://data.vlaanderen.be/ns/mobiliteit#periode>
                  [ a       <http://data.europa.eu/m8g/PeriodOfTime> ;
                    <http://data.europa.eu/m8g/endTime>
                            "2021-01-21T17:00:00Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> ;
                    <http://data.europa.eu/m8g/startTime>
                            "2021-01-21T06:00:00Z"^^<http://www.w3.org/2001/XMLSchema#dateTime>
                  ] ;
          <https://data.vlaanderen.be/ns/mobiliteit#zone>
                  <https://private-api.gipod.vlaanderen.be/api/v1/mobility-hindrances/10590495/zones/317e0d17-1a07-4ad9-b19f-7780ea2e25f0> ;
          <https://gipod.vlaanderen.be/ns/gipod#gipodId>
                  10590495 .

  <https://private-api.gipod.vlaanderen.be/api/v1/ldes/mobility-hindrances>
          <https://w3id.org/tree#member>  <https://private-api.gipod.vlaanderen.be/api/v1/mobility-hindrances/10590495/973> .

  <https://private-api.gipod.vlaanderen.be/api/v1/mobility-hindrances/10590495/zones/317e0d17-1a07-4ad9-b19f-7780ea2e25f0>
          a       <https://data.vlaanderen.be/ns/mobiliteit#Zone> ;
          <http://www.w3.org/ns/locn#geometry>
                  [ a       <http://www.w3.org/ns/locn#Geometry> ;
                    <http://www.opengis.net/ont/geosparql#asWKT>
                            "<http://www.opengis.net/def/crs/EPSG/9.9.1/31370> POLYGON ((95546.9552656286 159461.9612512481, 95547.04574184009 159461.96319760388, 95547.13603738231 159461.96923483865, 95547.22596738115 159461.97935059154, 95547.31534771094 159461.99352415127, 95547.40399537141 159462.0117264984, 95547.4917288624 159462.03392036483, 95547.57836855543 159462.06006031015, 95547.6637370615 159462.09009281447, 95547.74765959433 159462.12395638833, 95547.82996432808 159462.16158169828, 95547.91048274934 159462.20289170902, 95547.98905000198 159462.24780184106, 95548.06550522482 159462.29622014388, 95548.13969188088 159462.34804748427, 95548.21145807793 159462.4031777492, 95548.28065687948 159462.4614980631, 95548.34714660558 159462.52288901902, 95548.41079112295 159462.5872249231, 95548.47146012372 159462.65437405187, 95548.52902939213 159462.72419892196, 95548.58338105895 159462.79655657161, 95548.63440384278 159462.87129885334, 95548.68199327785 159462.94827273735, 95548.72605192798 159463.0273206247, 95548.76648958602 159463.10828067016, 95548.80322345858 159463.19098711343, 95548.83617833549 159463.27527061853, 95548.86528674384 159463.36095862067, 95548.89048908609 159463.44787567938, 95548.91173376216 159463.53584383774, 95548.92897727496 159463.62468298685, 95548.94218431957 159463.71421123447, 95548.95188662251 159463.81151022573, 95548.95682172895 159463.909167141, 95548.95697784246 159464.00694855035, 95548.95235458991 159464.1046207261, 95548.94296302229 159464.2019502018, 95548.9288255883 159464.29870433008, 95548.90997608079 159464.3946518389, 95548.88645955584 159464.4895633842, 95548.85833222518 159464.5832120983, 95548.82566132175 159464.67537413197, 95548.78852493908 159464.76582918965, 95548.7470118445 159464.854361056, 95548.70122126705 159464.94075811267, 95548.6512626603 159465.02481384412, 95548.59725544063 159465.1063273314, 95548.53932870191 159465.18510373216, 95548.47762090682 159465.26095474671, 95548.41227955594 159465.33369906776, 95548.34346083515 159465.40316281407, 95548.27132924236 159465.46917994594, 95548.1960571942 159465.53159266216, 95548.11782461399 159465.59025177718, 95548.03681850163 159465.6450170777, 95547.9532324866 159465.6957576578, 95547.86726636514 159465.742352232, 95547.77912562268 159465.78468942485, 95547.68902094265 159465.82266803752, 95547.59716770294 159465.85619728942, 95547.50378546097 159465.88519703542, 95547.409097429 159465.90959795713, 95547.31332994049 159465.9293417289, 95547.21671190913 159465.94438115705, 95547.20453876552 159465.94593431955, 95517.57953876552 159469.63343431955, 95517.56735632104 159469.6349127598, 95517.4699996292 159469.6440178647, 95517.37231427104 159469.64835366668, 95517.27453374452 159469.6479098018, 95517.17689177516 159469.6426873311, 95517.07962175725 159469.6326987378, 95516.98295619599 159469.6179678978, 95516.88712615176 159469.59853002228, 95516.7923606878 159469.5744315737, 95516.69888632269 159469.54573015484, 95516.60692648884 159469.51249437084, 95516.51670099849 159469.47480366545, 95516.42842551829 159469.43274813102, 95516.34231105374 159469.3864282932, 95516.25856344485 159469.33595487062, 95516.17738287413 159469.28144851027, 95516.09896338807 159469.2230394991, 95516.02349243332 159469.16086745256, 95515.95115040865 159469.09508098094, 95515.88211023371 159469.02583733413, 95515.81653693572 159468.95330202568, 95515.754587255 159468.87764843728, 95515.6964092703 159468.79905740422, 95515.64214204489 159468.7177167832, 95515.59191529409 159468.6338210033, 95515.54584907526 159468.5475706012, 95515.50405350082 159468.45917174182, 95515.46662847501 159468.36883572562, 95515.43366345516 159468.27677848338, 95515.40523723776 159468.18322006022, 95515.38141777022 159468.08838408947, 95515.36226198838 159467.99249725824, 95515.34781568043 159467.8957887655, 95515.3381133775 159467.79848977426, 95515.33317827106 159467.70083285897, 95515.33302215755 159467.60305144964, 95515.3376454101 159467.50537927388, 95515.34703697772 159467.4080497982, 95515.36117441171 159467.3112956699, 95515.38002391922 159467.2153481611, 95515.40354044417 159467.12043661578, 95515.43166777483 159467.02678790168, 95515.46433867826 159466.93462586802, 95515.50147506093 159466.84417081033, 95515.5429881555 159466.75563894399, 95515.58877873296 159466.6692418873, 95515.6387373397 159466.58518615586, 95515.69274455938 159466.5036726686, 95515.7506712981 159466.42489626782, 95515.81237909319 159466.34904525327, 95515.87772044407 159466.27630093222, 95515.94653916486 159466.20683718592, 95516.01867075765 159466.14082005405, 95516.0939428058 159466.07840733783, 95516.17217538602 159466.0197482228, 95516.25318149838 159465.96498292228, 95516.3367675134 159465.91424234217, 95516.42273363487 159465.867647768, 95516.51087437733 159465.82531057514, 95516.60097905736 159465.78733196246, 95516.69283229706 159465.75380271056, 95516.78621453904 159465.72480296457, 95516.880902571 159465.70040204286, 95516.97667005952 159465.6806582711, 95517.07328809088 159465.66561884293, 95517.08546123448 159465.66406568044, 95546.71046123448 159461.97656568044, 95546.72264367896 159461.9750872402, 95546.83875296728 159461.9647783267, 95546.9552656286 159461.9612512481))"^^<http://www.opengis.net/ont/geosparql#wktLiteral>
                  ] ;
          <https://data.vlaanderen.be/ns/mobiliteit#Zone.type>
                  <https://private-api.gipod.vlaanderen.be/api/v1/taxonomies/zonetypes/0fb72ef7-6ac9-4a70-b295-a30ea215d250> .

  <https://private-api.gipod.vlaanderen.be/api/v1/events/9197063>
          a       <https://data.vlaanderen.be/ns/mobiliteit#Evenement> ;
          <https://data.vlaanderen.be/ns/mobiliteit#Inname.heeftGevolg>
                  <https://private-api.gipod.vlaanderen.be/api/v1/mobility-hindrances/10590495/973> ;
          <https://gipod.vlaanderen.be/ns/gipod#gipodId>
                  9197063 .

  <https://private-api.gipod.vlaanderen.be/api/v1/taxonomies/statuses/a411c53e-db33-436a-9bb9-d62d535b661d>
          <http://www.w3.org/2004/02/skos/core#prefLabel>
                  "Onbekend"@nl-BE .
  ```

Publish this turtle:
```bash
curl -X POST http://localhost:8080/mobility-hindrances -H "Content-Type: application/ttl" -d "@mobility-hindrance.ttl"
```
with this command.

To check out our LDES:

```bash
curl "http://localhost:8080/mobility-hindrances"
```

## Add a second collection to the LDES Server

- Next, let's add a second collection to collect observations:

  - A collection name "observations"
  - Will process members of type "https://data.vlaanderen.be/ns/mobiliteit#ObservationCollection"
  - Will have a default view, which provides a basic view using a paginated fragmention. This also enables snapshotting.

  ```bash
  curl -X 'POST' 'http://localhost:8080/admin/api/v1/eventstreams' \
  -H 'accept: text/turtle' \
  -H 'Content-Type: text/turtle' \
  --data-raw '@prefix ldes: <https://w3id.org/ldes#> .
              @prefix example: <http://example.org/> .
              @prefix dcterms: <http://purl.org/dc/terms/> .
              @prefix tree: <https://w3id.org/tree#>.
              @prefix sh:   <http://www.w3.org/ns/shacl#> .
              @prefix server: <http://localhost:8080/> .
              @prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
              @prefix collection:  <http://localhost:8080/observations/> .
              @prefix prov: <http://www.w3.org/ns/prov#> .


              </observations> a ldes:EventStream ;
                  ldes:timestampPath prov:generatedAtTime ;
                  ldes:versionOfPath dcterms:isVersionOf ;
                  example:memberType <https://data.vlaanderen.be/ns/mobiliteit#ObservationCollection> ;
                  example:hasDefaultView "true"^^xsd:boolean ;
                  tree:shape [
                      a sh:NodeShape ;
                  ] .

              collection:timebased tree:viewDescription [
                    tree:fragmentationStrategy ([
                      a tree:HierarchicalTimeBasedFragmentation ;
                      tree:maxGranularity "day" ;
                          tree:fragmentationPath prov:generatedAtTime ;
                      ]) ;
                      tree:pageSize "100"^^<http://www.w3.org/2001/XMLSchema#int> ;
                  ] .
              
              collection:pagination tree:viewDescription [
                  tree:fragmentationStrategy  () ;
                    tree:pageSize "100"^^<http://www.w3.org/2001/XMLSchema#int> ;
                ] .
              '
  ```



## Add observation data to the LDES Server

- Create a `observation.ttl` file with the following content:

  ```turtle
  @prefix dc: <http://purl.org/dc/terms/> .
  @prefix prov: <http://www.w3.org/ns/prov#> .
  @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
  @prefix sosa: <http://www.w3.org/ns/sosa/> .
  @prefix ns0: <http://def.isotc211.org/iso19156/2011/SamplingFeature#SF_SamplingFeatureCollection.> .
  @prefix ns1: <http://def.isotc211.org/iso19156/2011/Observation#OM_Observation.> .
  @prefix ns2: <http://def.isotc211.org/iso19103/2005/UnitsOfMeasure#Measure.> .
  @prefix ns3: <https://schema.org/> .

  <urn:ngsi-ld:WaterQualityObserved:woq:1/2023-03-12T18:31:17.003Z>
  dc:isVersionOf <urn:ngsi-ld:WaterQualityObserved:woq:1> ;
  prov:generatedAtTime "2023-03-12T18:31:17.003Z"^^xsd:dateTime ;
  sosa:hasFeatureOfInterest "spt-00035-79" ;
  ns0:member <https://data.vmm.be/id/loc-00019-33>, [
      sosa:madeBySensor <urn:ngsi-v2:cot-imec-be:Device:imec-iow-UR5gEycRuaafxnhvjd9jnU> ;
      ns1:result [ ns2:value [
          ns3:value 2.043000e+1 ;
          ns3:unitCode <https://data.vmm.be/id/CEL>
      ] ] ;
      ns1:phenomenonTime "2023-03-12T18:31:17.003Z"^^xsd:datetime ;
      ns1:observedProperty <https://data.vmm.be/concept/waterkwaliteitparameter/temperatuur> ;
      ns1:featureOfInterest <https://data.vmm.be/id/spt-00035-79> ;
      a <http://def.isotc211.org/iso19156/2011/Measurement#OM_Measurement>
  ], [
      sosa:madeBySensor <urn:ngsi-v2:cot-imec-be:Device:imec-iow-UR5gEycRuaafxnhvjd9jnU> ;
      ns1:result [ ns2:value [
          ns3:value 1442 ;
          ns3:unitCode <https://data.vmm.be/id/HP>
      ] ] ;
      ns1:phenomenonTime "2023-03-12T18:31:17.003Z"^^xsd:datetime ;
      ns1:observedProperty <https://data.vmm.be/concept/observatieparameter/hydrostatische-druk> ;
      ns1:featureOfInterest <https://data.vmm.be/id/spt-00035-79> ;
      a <http://def.isotc211.org/iso19156/2011/Measurement#OM_Measurement>
  ], [
      sosa:madeBySensor <urn:ngsi-v2:cot-imec-be:Device:imec-iow-UR5gEycRuaafxnhvjd9jnU> ;
      ns1:result [ ns2:value [
          ns3:value 6150 ;
          ns3:unitCode <https://data.vmm.be/id/G42>
      ] ] ;
      ns1:phenomenonTime "2023-03-12T18:31:17.003Z"^^xsd:datetime ;
      ns1:observedProperty <https://data.vmm.be/concept/waterkwaliteitparameter/conductiviteit> ;
      ns1:featureOfInterest <https://data.vmm.be/id/spt-00035-79> ;
      a <http://def.isotc211.org/iso19156/2011/Measurement#OM_Measurement>
  ] ;
  a <https://data.vlaanderen.be/ns/mobiliteit#ObservationCollection> .

  <https://data.vmm.be/id/loc-00019-33> a <http://def.isotc211.org/iso19156/2011/SpatialSamplingFeature#SF_SpatialSamplingFeature> .
  ```

- Run the following command to post the `observation.ttl` to the LDES Server.

  ```bash
  curl -X POST http://localhost:8080/observations -H "Content-Type: application/ttl" -d "@observation.ttl"
  ```

To check out our LDES:
```bash
curl "http://localhost:8080/observations"
```


Because the LDES is configured to provide both pagination fragmentation and time-based fragmentation, it is possible to also crawl on these fragmentations. In this way, you can visit the endpoint of the timebased fragmentation view: http://localhost:8080/observations/timebased, but also the endpoint of the pagination fragmentation view: http://localhost:8080/observations/pagination.





```bash
curl "http://localhost:8080/observations/timebased?year=2023&month=03&day=12&pageNumber=1"
```



{: .note}
Note that you can create more than one view of a LDES, even for simple pagination by specifying a different view URI and page size. Later when we learn about retention policies and different fragmentation strategies, this may make more sense. For now remember that you can create a view before or after you ingest data, You can delete views and re-create them with different options. For this, you will need to use the administration API. This, you can find on http://localhost:8080/v1/swagger-ui/index.html





## Replicating an LDES using the LDES Client

- Create a `ldio.yml` file in the same directory as your `docker-compose.yml` with the following content:

  ```yaml
  orchestrator:
    pipelines:
      - name: gipod-replicator
        description: "HTTP polling, OSLO transformation, version creation & HTTP sending."
        input:
          name: be.vlaanderen.informatievlaanderen.ldes.ldi.client.LdioLdesClient
          config:
            url: https://private-api.gipod.vlaanderen.be/api/v1/ldes/mobility-hindrances
        outputs:
          - name: be.vlaanderen.informatievlaanderen.ldes.ldio.LdioHttpOut
            config:
              endpoint: http://ldio-workbench:8080/mobility-hindrances
              content-type: application/n-quads
  ```

- Execute the following command to start up the LDIO `docker compose up ldio-workbench -d`

- Validate your LDES server is being populated by going to `http://localhost:8080/mobility-hindrances/by-page?pageNumber=1` and `http://localhost:8080/mobility-hindrances/time-based`. These streams should fill up as the LDES Client send members to your server.

## Tear down the infrastructure and remove the volumes

- Within the working directory, please run `docker rm -f $(docker ps -a -q)`
