---
title: 8. Metadata catalogue (DCAT)
layout: home
nav_order: 8
---

# Metadata catalogue (DCAT)

[DCAT](https://www.w3.org/TR/vocab-dcat-3/) is an RDF vocabulary for data catalogues on the Web, enabling easy interoperability and discoverability of metadata for datasets, data services, and portals. It standardises properties for describing datasets, access information, and data services. By using DCAT, publishers can increase their datasets' exposure and facilitate data sharing and reuse.

{: .note}
The LDES Server building block allows to pass a static RDF file on startup, containing DCAT to describe the LDES(es). The server reads and publishes the content.





DCAT is an RDF vocabulary designed to facilitate interoperability between data catalogs published on the Web. This document defines the schema and provides examples for its use.

DCAT enables a publisher to describe datasets and data services in a catalog using a standard model and vocabulary that facilitates the consumption and aggregation of metadata from multiple catalogs. This can increase the discoverability of datasets and data services. It also makes it possible to have a decentralized approach to publishing data catalogs and makes federated search for datasets across catalogs in multiple sites possible using the same query mechanism and structure. Aggregated DCAT metadata can serve as a manifest file as part of the digital preservation process.

For more info on DCAT, visit the [DCAT publication](https://www.w3.org/TR/vocab-dcat-2/)

{: .note }
All DCAT API endpoints can be found on the Swagger UI endpoint configured in [the run guide.](../how-to-run)