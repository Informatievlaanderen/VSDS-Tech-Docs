curl -X 'POST' 'http://localhost:8080/admin/api/v1/eventstreams' \
-H 'accept: text/turtle' \
-H 'Content-Type: text/turtle' \
--data-raw '@prefix ldes: <https://w3id.org/ldes#> .
            @prefix dcterms: <http://purl.org/dc/terms/> .
            @prefix tree: <https://w3id.org/tree#>.
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
            @prefix example: <http://example.org/> .
            @prefix collection: <http://localhost:8080/mobility-hindrances/> .
            @prefix server: <http://localhost:8080>

            </mobility-hindrances> a ldes:EventStream ;
                ldes:timestampPath dcterms:created ;
                ldes:versionOfPath dcterms:isVersionOf ;
                example:memberType <https://data.vlaanderen.be/ns/mobiliteit#Mobiliteitshinder> ;
                example:hasDefaultView "true"^^xsd:boolean ;
                ldes:view collection:time-based ;
                tree:shape [
                    a sh:NodeShape ;
                ] .

            <mobility-hindrances/by-time> tree:viewDescription [
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
