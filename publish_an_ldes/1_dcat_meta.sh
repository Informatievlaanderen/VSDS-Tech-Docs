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