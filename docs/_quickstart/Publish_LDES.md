---
title: Publish an LDES
parent: Quick start
layout: home
sort: 0
---

# Publish an LDES

This example focuses on both publishing and consuming a [Linked Data Event Stream](https://semiceu.github.io/LinkedDataEventStreams/) (LDES). We start by explaining how to setup an LDES server and publish data as an LDES, followed by the setup of the LDES client to replicate an LDES. In this example, the data examples are described with [OSLO](https://data.vlaanderen.be/) (the Flemish Interoperability Program) ontologies.

<a href="https://github.com/Informatievlaanderen/VSDS-Tech-Docs/tree/main/docs/files/quickstart" download>
The files you will use for this quick start guide is available here
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
      image: ldes/ldes-server:1.0.0-SNAPSHOT
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

- Run `docker compose up` within the work directory of `.yml` file, to start the containers.
- The LDES Server is now available at port `8080` and accepts members via `HTTP POST` requests.
- We will now configure the LDES Server. (note that this part can also be done with the Swagger endpoint (`/v1/swagger`), where more detailed documentation is available)

- Let's set the DCAT metadata for the server by defining a title and a description:

```bash
curl -X 'POST' \
  'http://localhost:8080/admin/api/v1/dcat' \
  -H 'accept: text/plain' \
  -H 'Content-Type: text/turtle' \
  ---data-raw '  @prefix dct:   <http://purl.org/dc/terms/> .
                 @prefix dcat:  <http://www.w3.org/ns/dcat#> .

                 [] a dcat:Catalog ;
                    dct:title "My LDES'\''es"@en ;
                    dct:description "All LDES'\''es from publiser X"@en .
        '
```

- Next, let's add collection for our mobility hindrances. This will be used to replicate the dataset from GIPOD:

  - A collection name "mobility-hindrances"
  - Will process members of type "https://data.vlaanderen.be/ns/mobiliteit#Mobiliteitshinder"
  - Will have 2 views :
    - A default view, which provides a basic view using a paginated fragmention. This also enables snapshotting. (this view is called `by-page` by default)
    - A time-based fragmented view. This will fragment the members based on their timebased property. This value is by default set to `http://www.w3.org/ns/prov#generatedAtTime`

  ```bash
  curl -X 'PUT' 'http://localhost:8080/admin/api/v1/eventstreams' \
  -H 'accept: text/turtle' \
  -H 'Content-Type: text/turtle' \
  --data-raw '@prefix ldes: <https://w3id.org/ldes#> .
              @prefix dcterms: <http://purl.org/dc/terms/> .
              @prefix tree: <https://w3id.org/tree#>.
              @prefix sh:   <http://www.w3.org/ns/shacl#> .
              @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
              @prefix example: <http://example.org/> .
              @prefix collection: </mobility-hindrances/> .


              </mobility-hindrances> a ldes:EventStream ;
                  ldes:timestampPath dcterms:created ;
                  ldes:versionOfPath dcterms:isVersionOf ;
                  example:memberType <https://data.vlaanderen.be/ns/mobiliteit#Mobiliteitshinder> ;
                  example:hasDefaultView "true"^^xsd:boolean ;
                  ldes:view collection:time-based ;
                  tree:shape [
                      a sh:NodeShape ;
                  ] .

              collection:time-based tree:viewDescription [
                  ldes:retentionPolicy [
                      a ldes:DurationAgoPolicy  ;
                      tree:value "PT2M"^^xsd:duration ;
                  ] ;
                  tree:fragmentationStrategy ([
                      a tree:Fragmentation ;
                      tree:name "timebased" ;
                      tree:memberLimit "20" ;
                  ]) ;
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
  'http://localhost:8080/admin/api/v1/eventstreams/mobility-hindrances/views/time-based/dcat' \
  -H 'accept: */*' \
  -H 'Content-Type: text/turtle' \
  -d '@prefix dct:   <http://purl.org/dc/terms/> .
      @prefix dcat:  <http://www.w3.org/ns/dcat#> .

      [] a dcat:DataService ;
      dct:title "My timebased view"@en ;
      dct:description "Timebased fragmentation for the mobility-hindrances "@en .
      '
  ```

- Next, let's add a second collection to collect observations:

  - A collection name "observations"
  - Will process members of type "https://data.vlaanderen.be/ns/mobiliteit#ObservationCollection"
  - Will have a default view, which provides a basic view using a paginated fragmention. This also enables snapshotting.

  ```bash
  curl -X 'PUT' 'http://localhost:8080/admin/api/v1/eventstreams' \
  -H 'accept: text/turtle' \
  -H 'Content-Type: text/turtle' \
  --data-raw '@prefix ldes: <https://w3id.org/ldes#> .
              @prefix example: <http://example.org/> .
              @prefix dcterms: <http://purl.org/dc/terms/> .
              @prefix tree: <https://w3id.org/tree#>.
              @prefix sh:   <http://www.w3.org/ns/shacl#> .
              @prefix server: <http://localhost:8080/> .
              @prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .


              server:observations a ldes:EventStream ;
                  ldes:timestampPath dcterms:created ;
                  ldes:versionOfPath dcterms:isVersionOf ;
                  example:memberType <https://data.vlaanderen.be/ns/mobiliteit#ObservationCollection> ;
                  example:hasDefaultView "true"^^xsd:boolean ;
                  tree:shape [
                      a sh:NodeShape ;
                  ] .
              '
  ```

## Add data to the LDES Server

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
              endpoint: http://host.docker.internal:8080/mobility-hindrances
              content-type: application/n-quads
  ```

- Execute the following command to start up the LDIO `docker compose up ldio-workbench -d`

- Validate your LDES server is being populated by going to `http://localhost:8080/mobility-hindrances/by-page?pageNumber=1` and `http://localhost:8080/mobility-hindrances/time-based`. These streams should fill up as the LDES Client send members to your server.

## Tear down the infrastructure and remove the volumes

- Within the working directory, please run `docker rm -f $(docker ps -a -q)`
