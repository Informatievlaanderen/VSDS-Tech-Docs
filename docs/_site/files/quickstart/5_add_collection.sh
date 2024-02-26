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
            @prefix collection:  <http://localhost:8080/observations> .


            </observations> a ldes:EventStream ;
                ldes:timestampPath dcterms:created ;
                ldes:versionOfPath dcterms:isVersionOf ;
                example:memberType <https://data.vlaanderen.be/ns/mobiliteit#ObservationCollection> ;
                example:hasDefaultView "true"^^xsd:boolean ;
                tree:shape [
                    a sh:NodeShape ;
                ] .


            
            '
