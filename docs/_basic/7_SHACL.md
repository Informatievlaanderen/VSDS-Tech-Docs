---
title: 9. SHACL validation
layout: home
nav_order: 9
---

# SHACL validation

[SHACL (Shapes Constraint Language)](https://www.w3.org/TR/shacl/) is a standard for validating RDF data and ensuring that it conforms to a particular structure or shape. In the context of the Linked Data Event Stream (LDES), SHACL shapes are used to provide a machine-readble description of the expected structure of members in the stream.

By incorporating SHACL shapes, LDES provides a powerful tool for ensuring data quality and consistency, making it a reliable and trustworthy source of data for various applications. By defining a SHACL shape for the LDES, data producers can ensure that the members they add to the LDES adhere to the required structure, while data consumers can use the shape to validate and reason about the data they receive.

{: .note}
As a consequence of the immutability of the members, this shape _may_ evolve, but it **must** always be backwards compatible to the earlier version. When the new shape is not backwards compatible, a new LDES must be created.



SHACL (Shapes Constraint Language) is a standard for validating RDF data and ensuring 
that it conforms to a particular structure or shape. 
In the context of the Linked Data Event Stream (LDES), SHACL shapes are used to provide 
a machine-readable description of the expected structure of members in the stream.

By incorporating SHACL shapes, LDES provides a powerful tool for ensuring data quality 
and consistency, making it a reliable and trustworthy source of data for various 
applications. 
By defining a SHACL shape for the LDES, data producers can ensure that the members 
they add to the LDES adhere to the required structure, while data consumers can use 
the shape to validate and reason about the data they receive.

Defining a shape can be done through the `/admin/api/eventstreams/{event stream}/shape` endpoint.

For more info, visit the Swagger API endpoint configured in [the run guide.](../how-to-run)

### Example

````turtle
@prefix sh:   <http://www.w3.org/ns/shacl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .

[] a sh:NodeShape;
  sh:targetClass <https://w3id.org/ldes#EventStream> ;
  sh:closed true;
  sh:ignoredProperties (rdf:type) ;
  sh:property [
    sh:class sh:NodeShape;
    sh:description "The schema all elements of the eventstream must conform to."@en;
    sh:maxCount 1;
    sh:minCount 1;
    sh:name "shape"@en;
    sh:path <https://w3id.org/tree#shape>
  ], [
    sh:nodeKind sh:IRI ;
    sh:description "The object property of the members that idicates how members relate to each other from the time perspective."@en;
    sh:maxCount 1;
    sh:name "timestampPath"@en;
    sh:path <https://w3id.org/ldes#timestampPath>
  ], [
    sh:nodeKind sh:IRI ;
    sh:description "The object property that indicates the object identifier in a version object."@en;
    sh:maxCount 1;
    sh:name "versionOfPath"@en;
    sh:path <https://w3id.org/ldes#versionOfPath>
  ] .
````
