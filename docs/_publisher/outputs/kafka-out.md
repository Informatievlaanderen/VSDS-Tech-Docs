---
layout: default
parent: 4. Output components
title: Kafka Out
---

# Kafka Out

<b>LDIO Component Name:</b> <i>`Ldio:LdioKafkaIn`</i> see [reference guide]() <br>
<b>Apache Nifi Component Name:</b> <i>`ConsumeKafka`</i> see [Apache Nifi reference guide](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi/nifi-kafka-2-0-nar/1.24.0/org.apache.nifi.processors.kafka.pubsub.ConsumeKafka_2_0/index.html)

<br>

The Kafka Out sends messages to a [kafka topic](https://kafka.apache.org).

```mermaid
graph LR
    LDES --> C[Client]
    C --> H[LDIO Kafka Out Component]
    H --> S[Kafka topic]

    subgraph Publishing Pipeline
    C
    H
    end
```
