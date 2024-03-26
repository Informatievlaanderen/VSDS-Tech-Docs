---
layout: default
title: Repository Materialization
parent: 4. Output components
---

# Repository Materialiser

<b>LDIO Component Name:</b> <i>`Ldio:RepositoryMaterialiser`</i> see [reference guide]() <br>
<b>Apache Nifi Component Name:</b> <i>`RepositoryMaterialiser` </i> see [reference guide]()

<br>

The repository materialiser is used to materialise an LDES stream into a triplestore.
Any triplestore that supports the RDF4J remote repository API can be used.

```mermaid
graph LR
    L[LDES members] --> H[Repository Materialiser]
    H --> S[Tripple Store]

    subgraph Publishing Pipeline
    H
    end
```


### Batching

To increase the performance of this materialiser, members will be committed in batch to the triple store. However, it's
important to notice that this can have an impact on the data integrity. First of all, there could be a delay, with a
maximum delay of the configured batch timeout, when the triple store will be up-to-date. Secondly, if something goes
wrong halfway of a batch, all the members in that batch will not be committed to triple story and thus will be gone.

So the more important data integrity is, the lower the `batch-size` and `batch-timeout` should be configured. If a more
performant repository materialiser is desired, `batch-size` and `batch-timeout` should be configured somewhat higher. 