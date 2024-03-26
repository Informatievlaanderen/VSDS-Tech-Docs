---
title: Release management
layout: home
nav_order: 5
---

# Release management

## LDES Server [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Informatievlaanderen_VSDS-LDESServer4J&metric=alert_status&?style=social)](https://sonarcloud.io/summary/new_code?id=Informatievlaanderen_VSDS-LDESServer4J)

### Versions: 

* Latest Official version: [![Docker Image Version](https://img.shields.io/docker/v/ldes/ldes-server/latest)](https://hub.docker.com/r/ldes/ldes-server/tags)
* Latest Alpha version: [![Docker Image Version](https://img.shields.io/docker/v/ldes/ldes-server)](https://hub.docker.com/r/ldes/ldes-server/tags)

Go to the [LDES Server Github Releases](https://github.com/Informatievlaanderen/VSDS-LDESServer4J/releases/) for all the releases.

## Linked Data Interactions [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Informatievlaanderen_VSDS-Linked-Data-Interactions&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Informatievlaanderen_VSDS-Linked-Data-Interactions)

The Linked Data Interactions Repo (LDI) is a bundle of basic SDKs used to receive, generate, transform and output Linked Data. This project is set up in the context of the VSDS Project to ease adopting LDES on data consumer and producer side.

Go to the [LDI Github Releases](https://github.com/Informatievlaanderen/VSDS-Linked-Data-Interactions/releases/) for all the releases.

### Linked Data Interactions Orchestrator (LDIO) 

The Linked Data Interactions Orchestrator is built to be a lightweight Linked Data pipeline framework.

For more detail on how to use the LDIO, please visit the [LDIO Documentation](https://informatievlaanderen.github.io/VSDS-Linked-Data-Interactions/ldio).

#### Versions:

* Latest Official version: [![Docker Image Version](https://img.shields.io/docker/v/ldes/ldi-orchestrator/latest)](https://hub.docker.com/r/ldes/ldi-orchestrator/tags)
* Latest Alpha version: [![Docker Image Version](https://img.shields.io/docker/v/ldes/ldi-orchestrator)](https://hub.docker.com/r/ldes/ldi-orchestrator/tags)

### Linked Data Interactions for Apache NiFi

To also support existing users of Apache NiFi, all LDI components have been made available as NiFi component.
For that, a specially bundled NiFi Docker image is available.

Documentation on how to use the individual Processors can be found in the in-app documentation and on [the LDI NiFi docs](https://informatievlaanderen.github.io/VSDS-Linked-Data-Interactions/ldi-nifi).

#### Versions:

* Latest Official version: [![Docker Image Version](https://img.shields.io/docker/v/ldes/ldi-workbench-nifi/latest)](https://hub.docker.com/r/ldes/ldi-workbench-nifi/tags)
* Latest Alpha version: [![Docker Image Version](https://img.shields.io/docker/v/ldes/ldi-workbench-nifi)](https://hub.docker.com/r/ldes/ldi-workbench-nifi/tags)


## Which version should I use?

* As a general recommendation, the **official release** is the goto version to use. This is the ideal version to use on Production.
* The **alpha/snapshot versions** available on dockerhub provide a certain stability, but have not been internally validated on specification compliance. These versions can be used for non-production environments (test/acceptance/...)
* The images found on **GitHub** itself should not be used for anything other than testing, they are prone to changes and do not come with any support.

## Notification of new releases

To get informed when a new version of a building block is released, go to 'watch'.
On the [notifications](https://github.com/notifications) page, you can see your personal notification subscribtions
