---
title: Home
layout: home
nav_order: 0
---

# How to share data in the Flanders Smart Data Space

This technical documentation is here to guide you through the <u>pipeline architecture</u> that needs to be set up to share and collect data within the Flanders Smart Data Space. The Flanders Smart Data Space allows you to <u>publish</u> and <u>consume</u> both <u>open and closed data</u> efficiently. For this purpose, a technical standard (Linked Data Event Streams) has been chosen that allows data users to be kept in sync with different dynamic source data sets. It allows data to be exchanged between silos sustainably and cost-effectively using domain-specific ontology for fast and slowly changing data streams.

<br>

Before exploring how to set up data pipelines, make sure to familiarize yourself with the foundational concepts. This includes understanding what the [Flanders Smart Data Space](https://www.vlaanderen.be/vlaamse-smart-data-space-portaal) is all about, grasping the [Linked Data principle](/basic/1_linked_data.html), and knowing what a [Linked Data Event Stream (LDES)](/basic/2_introduction.html) typically entails.

## Set up your Pipeline, and you are good to go

To either publish your data with or access data from the Flanders Smart Data Space, setting up a pipeline is essential. You can kickstart this process instantly using open-source Java components that are ready to run in a docker container.

![alt text](image-1.png)

<br>

Are you a <b>data publisher</b> that wants to publish your data in the Flanders Smart Data Space as a Linked Data Event Stream (LDES)? We explain what the publishing pipeline should look like, without going too deeply into the specific configuration of the necessary building blocks. We will assist you in selecting the right open-source building blocks that fit your specific needs, focusing on ease of integration. After this, you can go directly to the tutorials, with the basic concepts and background knowledge in your backpocket.

<br>

Are you a <b>data consumer</b> eager to delve into your first LDES experience? Setting up a dedicated pipeline is once again essential. This round requires establishing a specialized consumption pipeline designed to sequentially harvest LDES members and propel them downstream. By assembling various components, you can create a customized LDES consuming pipeline tailored to your specific needs.

<br>

As a <b>data intermediary</b>, your objective is to collect LDES streams and then release a revamped, enriched LDES data stream. The capability to utilize data processing techniques for cleaning, restructuring, or augmenting the initial datasets requires the establishment of a specialized LDES consumption pipeline. Your role involves implementing a resilient and scalable pipeline that not only facilitates an uninterrupted data flow but also aligns with Linked Data principles, thereby transforming your enhanced LDES stream into a crucial resource within the data ecosystem.

<div style="display: flex; justify-content: space-around;">

<a href="/publishing/index.html">
<button style="background-color: #fafbfc; color: #666666; padding: 10px 20px; width: 200px; border: 0.3px solid rgb(0, 200, 171); border-radius: 10px; cursor: pointer;">
    Publishing Pipeline
</button></a>

<a href="/intermediary/index.html">
<button style="background-color: #fafbfc; color: #666666; padding: 10px 20px; width: 200px; border: 0.3px solid rgb(0, 200, 171); border-radius: 10px; cursor: pointer;">
    Intermediary Pipeline
    </button></a>

<a href="/consuming/index.html">
<button style="background-color: #fafbfc; color: #666666; padding: 10px 20px; width: 200px; border: 0.3px solid rgb(0, 200, 171); border-radius: 10px; cursor: pointer;">
    Consuming Pipeline
    </button></a>

</div>

<br>

## Learn by doing

Based on a few use cases, we try to teach you in a light-hearted way how to publish or consume an LDES. In these tech docs we do not go into depth about the different possible parameters, but we show a working configuration for the proposed use case. Detailed information about the technical parameters or configuration options can be found under sections of the building blocks individually.

<div style="display: flex; justify-content: space-around;">

<a href="https://github.com/Informatievlaanderen/VSDS-Onboarding-Example">
<button style="background-color: #fafbfc; color: #666666; padding: 10px 20px; width: 200px; border: 0.3px solid rgb(0, 200, 171); border-radius: 10px; cursor: pointer;">
        Tutorials (Learn by doing)
    </button>
</a>
</div>

## Building Blocks

Would you like more detailed information about the individual open-source building blocks? A complete hatch or section is dedicated to each individual building block. The purpose of these sections is to understand what different parameters you can use to get the perfect configuration of your building block.

<div style="display: flex; justify-content: space-around;">

<a href="/_consumer/index.html">
<button style="background-color: #fafbfc; color: #666666; padding: 10px 20px; width: 200px; border: 0.3px solid rgb(0, 200, 171); border-radius: 10px; cursor: pointer;">
    Building blocks
</button></a>
</div>