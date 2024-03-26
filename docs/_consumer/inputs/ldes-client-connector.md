---
layout: default
parent: 1. Input components
title: LDES Client with Connector
nav_order: 1
---

# LDIO Ldes Client Connector

<b>LDIO connector name:</b> <i>`Ldio:LdioLdesClientConnector`</i> see [reference guide]()
<b>Apache Nifi Component Name:</b> <i>Ldio:LdioLdesClientConnector`</i> see [reference guide]()

<br>

This component adds EDC (Eclipse dataspace Connector) support to [the ldio ldes client](./ldio-ldes-client.md).

If you'd like to know how to configure
the LDES Client, we refer to [the ldio ldes client](./ldio-ldes-client.md).
The additional functionality provided by this component makes it possible to use the Ldes Client to consume an LDES
through an EDC connector.
This component exposes two endpoints:

1. http://<host>:<port>/<pipelines.name>/transfer
   The Ldio component will start the data transfer with the connector. You have to send the transfer request to
   the LdioLdesClientConnector instead of the EDC consumer connector. The LDIO Ldes Client Connector will start the
   transfer
   with the connector and also keep the transfer alive while consuming the LDES (e.g. request a new token when it
   expires).
2. http://<host>:<port>/<pipelines.name>/token
   This endpoint should never be called directly. This is the callback to be provided in the transfer request.
   The EDC connector will use this callback endpoint to provide the LDES Client with a token.

![img](./art/ldes-client-connector.svg)
