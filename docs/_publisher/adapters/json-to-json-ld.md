---
layout: default
parent: LD Pipeline Adapters
title: Json To JsonLd Transformer
---

# LDIO Json To JsonLd Transformer

<b>LDIO Component Name:</b> <i>`Ldio:JsonToLdAdapter`</i> see [reference guide]() <br>
<b>Apache Nifi Component Name:</b> <i>`
Json to Json LD Processor` </i> see [reference guide]()

The json-to-ld-adapter receives json messages and adds a linked data context to transform the messages to json-ld. The JSON-to-LD Adapter is designed to bridge the gap between conventional JSON messages and the more semantically rich JSON-LD (JSON for Linked Data). At its core, this adapter takes incoming JSON messages, which are widely used for their simplicity and flexibility in data interchange, and enhances them by appending a linked data context. 

```mermaid
graph LR
    L[JSON] --> H[Json-to-JsonLD-Transformer]
    H --> S[Json-LD]

    subgraph Publishing Pipeline
    H
    end
```