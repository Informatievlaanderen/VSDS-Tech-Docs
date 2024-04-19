---
title: Publishing Pipeline
layout: home
nav_order: 0
---

# Publishing Pipeline

<br>

A <b>data publisher</b> publishes its data in the Flanders Smart Data Space as a Linked Data Event Stream (LDES). In order to do so, a publishing pipeline needs to be configured. Without going too deeply into the specific configuration of the necessary building blocks, this part assists you in how this publishing pipeline needs to look like. After this, you can go directly to the tutorials, with the basic concepts and background knowledge in your back pocket.

![alt text](image.png)

<br>

For instance, when a data publisher aims to distribute non-linked data as an LDES, a specifically configured publisher pipeline manages the entire process. Initially, an adapter component transforms the data into linked data. Subsequently, a transformer component converts the geometry into WKT format. Once the data is prepared for publication, it is transmitted to the LDES server using an HTTP-out component. It's important to note that the LDES server is not part of the pipeline; rather, it functions as a separate VSDS building block. For effective data publication, two services need to be deployed.

