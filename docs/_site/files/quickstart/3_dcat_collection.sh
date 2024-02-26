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
