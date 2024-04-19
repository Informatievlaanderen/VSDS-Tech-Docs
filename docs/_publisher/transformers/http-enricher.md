---
layout: default
parent: LD Pipeline Transformers
title: Http Enricher Transformer
---

# Http Enricher

<b>LDIO Component Name:</b> <i>`Ldio:HttpEnricher`</i> see [reference guide](https://informatievlaanderen.github.io/VSDS-Linked-Data-Interactions/ldio/ldio-transformers/ldio-http-enricher) <br>
<b>Apache Nifi Component Name:</b> <i>`...`</i> see [reference guide]()

<br>

A transformer that allows sending a GET or POST HTTP request to a dynamic URL provided by the model.
The response is converted to linked data and added to the incoming model.


```mermaid
graph LR
    L[GET/POST] --> H[Http Enricher]
    H --> S[Linked Data response]

    subgraph Publishing Pipeline
    H
    end
```
