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