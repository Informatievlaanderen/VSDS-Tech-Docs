---
title: Consuming pipeline
layout: home
nav_order: 0
---

# Consuming Pipeline

<br>

As a <b>data consumer</b>, you want to access and utilize data from the Flanders Smart Data Space. This data is offered in the form of Linked Data Event Streams. This section aims to guide you through the process of creating the perfect consumption pipeline, providing a broad overview without delving into the complexities of each pipeline component. Armed with this foundational knowledge, you can seamlessly transition to the tutorials, ready to apply the essential concepts and background information to your data consumption tasks.

![alt text](image-3.png)

For instance, if a data user intends to access data from an LDES and store it in a database (such as GraphDB), they will need to establish a consuming data pipeline. Initially, the configuration of the LDES client component is required. This component, an integral part of the data pipeline, sequentially retrieves each LDES member and forwards them through the process. Following this, a Repository Materializer component must be integrated into the pipeline to enable the writing of LDES members to the GraphDB.