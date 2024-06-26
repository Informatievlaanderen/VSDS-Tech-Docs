---
layout: default
parent: 1. Input components
title: HTTP In Poller
nav_order: 2
---

# HTTP In Poller

<b>LDIO Component Name:</b> <i>`Ldio:LdioHttpInPoller`</i>see [reference guide](https://informatievlaanderen.github.io/VSDS-Linked-Data-Interactions/ldio/ldio-inputs/ldio-http-in-poller) <br>

<b>Apache Nifi Component Name:</b> <i>`InvokeHTTP`</i> see [reference guide](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi/nifi-standard-nar/1.17.0/org.apache.nifi.processors.standard.InvokeHTTP/index.html)

<br>

The LDIO HTTP In Poller is a basic HTTP Poller that will poll a target URL on a specified interval. This component fetches data from an HTTP endpoint at a configured interval.

It is designed to process input in various content types, including XML (text/xml, application/xml), JSON (application/json), and RDF (text/turtle, application/ld+json, application/n-quads, application/n-triples, application/rdf+xml).

The expected output of the component is in these same formats, supporting XML, JSON, and RDF content types.

```mermaid
graph LR
    L[HTTP endpoint] --> H[HTTP poller component]
    H --> S[...]

    subgraph Publishing Pipeline
    H
    end
```
