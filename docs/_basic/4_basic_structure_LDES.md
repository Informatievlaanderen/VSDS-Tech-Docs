---
title: 4. Basic structure LDES
layout: home
nav_order: 4
---


# Structure of a Linked Data Event Stream

As defined above, an LDES is a collection of members or _immutable objects_. The LDES spec works both for fast moving data and slow moving data. An example of fast moving data, such as sensor observations, is shown in the example below.

{: .note}
The base URI for LDES is https://w3id.org/ldes#, with the preferred prefix being `ldes`.

```turtle
@prefix ldes: <http://w3id.org/ldes#> .
@prefix tree: <https://w3id.org/tree#> .
@prefix sosa: <http://www.w3.org/ns/sosa/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<C1> a ldes:EventStream ;
     ldes:timestampPath sosa:resultTime ;
     tree:shape <C1/shape.shacl> ;
     tree:member <observation1> .

<observation1> a sosa:Observation ;
               sosa:resultTime "2021-01-01T00:00:00Z"^^xsd:dateTime ;
               sosa:hasSimpleResult "..." .
```

{: .note}
The observation entity (`<observation1>`) is considered to be immutable, and its existing identifiers can be utilized as such.

The specification indicates that an `ldes:EventStream` **should** have the following properties:

- `tree:member` → indicating the members of the collection
- `tree:shape` → a machine-readable description of the members in the collection. Can be [SHACL](https://www.w3.org/TR/shacl/) or [ShEx](https://shex.io/).

Otherwise, an `ldes:EventStream` may have these properties:

- `ldes:timestampPath` → indicates how a member precedes another member in the LDES, using a timestamp.
- `ldes:versionOfPath` → indicating the non-version object. See [example](https://semiceu.github.io/LinkedDataEventStreams/#example-92fdebd4) in the specification.

As stated above, an LDES can also publish a slow moving dataset, such as street names. An example is shown below.

```turtle
@prefix ldes: <http://w3id.org/ldes#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms: <http://purl.org/dc/elements/1.1/> .
@prefix tree: <https://w3id.org/tree#> .
@prefix sosa: <http://www.w3.org/ns/sosa/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<C1> a ldes:EventStream ;
     tree:shape <C1/shape.shacl> ;
     tree:member <streetname1-v1>, <streetname1-v2> .

<streetname1-v1> rdfs:label "Station Road" ;
               dcterms:isVersionOf <streetname1> ;
               dcterms:created "2020-01-01T00:10:00Z"^^xsd:dateTime .

<streetname1-v2> rdfs:label "Station Square" ;
               dcterms:isVersionOf <streetname1> ;
               dcterms:created "2021-01-01T00:10:00Z"^^xsd:dateTime .
```

This example introduces the concept of **versions**, because certain entities, such as street names, do not understand the concept of time. In this example, versions of street names are published, ensuring the immutability of the LDES members. When publishing versions of entities, extra information (`dcterms:isVersionOf`) must be added in order to be able to link these version to an entity. Not introducing versions for entities that do not understand the concept of time would lead to an incorrect implementation of the LDES spec, as shown below.

```turtle
@prefix ldes: <http://w3id.org/ldes#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms: <http://purl.org/dc/elements/1.1/> .
@prefix tree: <https://w3id.org/tree#> .
@prefix sosa: <http://www.w3.org/ns/sosa/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<C1> a ldes:EventStream ;
     tree:shape <C1/shape.shacl> ;
     tree:member <streetname1> .

<streetname1> rdfs:label "Station Road" ;
               dcterms:created "2020-01-01T00:10:00Z"^^xsd:dateTime .

<streetname1> rdfs:label "Station Square" ;
               dcterms:created "2021-01-01T00:10:00Z"^^xsd:dateTime .
```

In this example, the entity with HTTP URI `<streetname1>` is not longer immutable, which is a direct conflict with the definition of the LDES spec.

{: .note}
It is important to note that once a client processes a member of an LDES, it should never have to process it again. Therefore, a Linked Data Event Stream client can maintain a list of already processed member IRIs in a cache. A reference implementation of a client is available as an open-source [SDK](https://github.com/Informatievlaanderen/VSDS-Linked-Data-Interactions/tree/main/ldi-core#1-ldes-client) as part of the Flanders Smart Data Space initiative.

<p align="center"><img src="https://informatievlaanderen.github.io/VSDS-Tech-documentation/assets/images/versioning.png" width="60%" text-align="center"></p>