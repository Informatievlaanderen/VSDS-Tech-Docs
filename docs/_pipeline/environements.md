---
title: Supported frameworks
layout: home
nav_order: 1
---

# Environments

<br>

Currently, we support 2 frameworks to use these building blocks in:

- [Apache Nifi](https://nifi.apache.org/): A powerful system to easily process and distribute data
- [Linked Data Interactions Orchestrator](ldio): A lightweight application developed and maintained in the frame of the Flanders Smart Data Space, without the deployment of Apache Nifi.

## Option 1: Apache Nifi

<b>Apache NiFi</b> is an open-source data processing and distribution system designed to automate the flow of data between systems. Its user-friendly interface allows for the quick design, control, and monitoring of data flows, making it an invaluable tool for managing complex data pipelines. In the context of Linked Data Event Streams (LDES), Apache NiFi can be used to consume, process, and send linked data members efficiently downstream, across different systems and environments. With its support for various data formats and protocols, NiFi can handle the intricacies of linked data, such as ensuring data integrity, maintaining semantic relationships, and facilitating the real-time processing of data streams. By leveraging NiFi's capabilities, users can streamline the ingestion, transformation, and dissemination of linked data, thereby enhancing the accessibility and utility of information within the Flanders Smart Data Space or similar environments. This makes Apache NiFi a powerful ally in harnessing the full potential of LDES, enabling organizations to unlock valuable insights from their data ecosystems.

## Option 2: Linked Data Interactions Orchestrator


Deploying Apache Nifi can sometimes be undesirable due to the high deployment costs involved. In response to this challenge, a lightweight application named <b>LDIO</b> has been developed and maintained within the Flanders Smart Data Space framework. LDIO is designed to offer a cost-effective alternative, significantly reducing the resources and financial investment required for deployment. 


## Which environment should I use?

<b>Error handling</b>
<br>

You would turn to the <b>Apache NiFi</b> environment when aiming to establish a robust data pipeline, especially when maintaining control over improperly handled data members becomes a priority. This scenario might include instances like incorrect geometry in the GeoJson-to-WKT (Well-Known Text) Processor, an LDES member failing to validate against a SHACL (Shapes Constraint Language) shape, among other potential issues. Apache NiFi's appeal lies in its comprehensive toolkit that allows for intricate control over data flows, including error handling mechanisms that enable users to identify, diagnose, and correct data processing anomalies. By using NiFi, you can ensure that each piece of data, regardless of its complexity or the intricacies involved in its processing, is managed effectively. This level of oversight and control is critical in environments where data accuracy, consistency, and reliability are paramount, making Apache NiFi an ideal choice for handling sophisticated data pipelines that demand rigorous error management and data integrity assurance.

If you're looking to quickly set up a data pipeline without the immediate need to build a safety net for instances where a data member is improperly processed by a component, we recommend using the <b>Linked Data Interactions environment</b>. This environment is designed for efficiency and ease of use, allowing you to streamline the pipeline construction process. It is particularly suitable for scenarios where the primary focus is on rapid development and deployment, and less on the intricate handling of data errors at the outset. The Linked Data Interactions environment offers a straightforward approach, making it an ideal choice for those who prioritize speed and simplicity in their data pipeline setup.

Nevertheless, there is a <b>debug logging</b> option in LDIO, so it becomes possible to track and analyze detailed operational information, helping developers and system administrators diagnose issues, understand application behavior, and optimize performance more effectively.

<b>Monitoring logging</b>
<br>

To provide a better insight in the workings in the LDIO, a Prometheus endpoint is exposed that encloses some metrics. In this way, developers and system administrators can monitor the system's performance and reliability in real-time, enabling quick identification and resolution of any issues that may arise.