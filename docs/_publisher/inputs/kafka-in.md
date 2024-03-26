---
layout: default
parent: 1. Input components
title: Kafka In
nav_order: 4
---

# Kafka In

<b>LDIO Component Name:</b> <i>`Ldio:LdioKafkaIn`</i> see [reference guide]() <br>
<b>Apache Nifi Component Name:</b> <i>`ConsumeKafka`</i> see [Apache Nifi reference guide](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi/nifi-kafka-2-0-nar/1.24.0/org.apache.nifi.processors.kafka.pubsub.ConsumeKafka_2_0/index.html)

<br>

The LDIO Kafka In component is vital to the Publishing Pipeline, specifically designed to interact with Kafka, a distributed event streaming platform. This component is responsible for listening to messages from a specified [kafka topic](https://kafka.apache.org), which is crucial in integrating with an LDES server.

```mermaid
graph LR
    L[Kafka topic] --> H[Kafka in component]
    H --> S[LDES server]

    subgraph Publishing Pipeline
    H
    end
```
