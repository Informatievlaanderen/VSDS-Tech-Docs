---
title: 3. What is a LDES?
layout: home
nav_order: 3
---

# What is a LDES?

The [Linked Data Event Stream (LDES) specification (ldes:EventStream)](https://semiceu.github.io/LinkedDataEventStreams/) allows data publisher to publish their dataset as an append-only collection of immutable members in its most basic form. Consumers can host one or more in-sync views on top of the default (append-only) view.

An LDES is defined as a collection of immutable objects, often referred to as _LDES members_.

These _members_ are described using a specific format called RDF, which stands for Resource Description Framework. RDF is one of the corner stones of Linked Data and on which LDES continues to build.

{: .highlight }
More information on Linked Data can be found [here](https://www.w3.org/wiki/LinkedData#:~:text=The%20term%20Linked%20Data%20refers,URIs%20as%20names%20for%20things).

The LDES specification is based on a hypermedia specification, called the [TREE specification](https://w3id.org/tree/specification). The TREE specification originates from the idea to provide an alternative to one-dimensional HTTP pagination. It allows to fragment a collection of items and interlink these fragments. Instead of linking to the next or previous page, the relation describes what elements can be found by following the link to another fragment. The LDES specification extends the TREE specification by stating that every item in the collection **_must_** be immutable. The TREE specification is compatible with other specifications such as [activitystreams-core](https://www.w3.org/TR/activitystreams-core/), [VOCAB-DCAT-2](https://www.w3.org/TR/vocab-dcat-2), [LDP](https://www.w3.org/TR/ldp/), or Shape Trees. For specific compatibility rules, please refer to the [TREE specification](https://w3id.org/tree/specification).

![](../images/spec.png)

LDESes apply --- as the term implies --- the Linked Data principles to data event streams. A data stream is typically a constant flow of distinct data points, each containing information about an event or change of state that originates from a system that continuously creates data. Some examples of data streams include sensor and other IoT data, financial data, etc.

Today, custom code has to be created to integrate data, which makes it rather expensive to integrate multiple data sources. With LDES, a technical standard was created that allows data to be exchanged across silos using domain-specific ontologies. An LDES allows third parties to build specific services (WFS, SPARQL endpoint) themselves on top of their own database that is always in sync with the original dataset.

An LDES is a constant flow of immutable objects (such as version objects of addresses, sensor observations or archived representations) containing information changes that originates from a system that continuously creates data. Compared to other event stream specification, the LDES specs opts to publish the entire object for every change.

Furthermore, LDES increases the usability and findability of data, as it comes in a uniform Linked Data standard published on an online URI endpoint. As a result, an LDES is self-descriptive meaning and more data can be found by following the links.

In a nutshell, there are several reasons why there was a need to develop the Linked Data Event Streams specification:

- Linked Data is a powerful paradigm for representing and sharing data on the Web. Still, it has traditionally focused on representing static data rather than events or changes to that data.

- The use of event streams is becoming increasingly prevalent on the Web, as it enables applications to exchange information about changes to data in real-time efficiently.

- There was a need for a semantic standard that provides a uniform way to exchange data so that different systems could easily exchange data.

- Linked Data Event Streams allow applications to subscribe to a stream of data and receive updates in real-time.

