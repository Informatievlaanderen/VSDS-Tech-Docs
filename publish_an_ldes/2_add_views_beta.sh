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
                

                collection:by-time tree:viewDescription [
                ldes:retentionPolicy [
                    a ldes:DurationAgoPolicy  ;
                    tree:value "PT2M"^^xsd:duration ;
                ] ;
                tree:fragmentationStrategy ([
                    a tree:HierarchicalTimeBasedFragmentation  ;
                    tree:maxGranularity "day" ;
                tree:fragmentationPath ldes:timestampPath ;
                ]) ;
                tree:pageSize "20"^^<http://www.w3.org/2001/XMLSchema#int> 
            ] .
            '