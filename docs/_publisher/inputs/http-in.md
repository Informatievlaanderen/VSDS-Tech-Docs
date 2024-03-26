---
layout: default
parent: 1. Input components
title: HTTP In
nav_order: 3
---

# LDIO HTTP In

<b>LDIO Component Name:</b> <i>`Ldio:LdioHttpIn`</i> see [reference guide]() <br>
<b>Apache Nifi Component Name:</b> <i>`InvokeHTTP`</i> see [Apache Nifi reference guide]()

<br>

The LDIO HTTP In is a basic HTTP Listener. This component listens for HTTP messages at the endpoint `http://{hostname}:{port}/{pipeline name}`.

It supports processing input in various content types, including XML (text/xml, application/xml), JSON (application/json), and RDF (text/turtle, application/ld+json, application/n-quads, application/n-triples, application/rdf+xml).

The expected output of this component is also in similar formats, supporting XML, JSON, and RDF content types.

```mermaid
graph LR
    L[endpoint HTTP messages] --> H[Http in Listener]
    H --> S[...]

    subgraph Publishing Pipeline
    H
    end
```

