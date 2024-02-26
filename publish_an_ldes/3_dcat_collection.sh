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