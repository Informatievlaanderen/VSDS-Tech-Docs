---
title: 5. Replication & synchronisation
layout: home
nav_order: 5
---

# Replication & synchronisation

## Replication

To initiate the replication of an LDES, data consumers must configure the LDES client with an LDES endpoint. If multiple views are available for the LDES, the LDES client will begin the replication process utilising the first view it receives. However, suppose a data consumer has a specific preference for a particular view to initiate the replication. In that case, it is also possible to configure the view URI in the LDES client accordingly.

<p align="center"><img src="/assets/images/replication.png" width="60%" text-align="center"></p>

When the client visits a fragment, it parses the content to RDF and discovers LDES members by looking for triples with the **tree:member**. Moreover, the client searches for triples with a **tree:relation** predicate, signifying links to other fragments, and adds them to its queue of fragments to be fetched if they still need to be retrieved. The client inspects the response headers for each fragment and looks for a potential _'Cache-control: immutable'_ attribute, indicating that the fragment is _immutable_ and does not need to be polled again.

## Synchronisation

In addition to replication, the LDES client keeps track of all _mutable_ fragments and periodically polls them to check if new LDES members were added. To further optimise the synchronisation process, the LDES client reads the _'Cache-control: max-age'_ value from the response headers, which specifies the time period for which the LDES fragment remains valid. This allows the LDES client to schedule periodic polling more efficiently.

<p align="center"><img src="/assets/images/synchronisation.png" width="60%" text-align="center"></p>

By utilising the response headers provided by the LDES server, the LDES client can effectively manage the synchronisation of the LDES stream, while minimising the amount of processing required. This makes the LDES client an efficient and reliable tool for processing and managing Linked Data Event Streams.

## Resuming

An essential functionality of the LDES client is _resuming_, enabling the client to halt and resume from where it last stopped. To achieve this functionality, the client utilises an SQLite database to persist the immutable and mutable fragment IDs, guaranteeing that an immutable fragment is only retrieved once. The member IDs are also saved in the database for mutable fragments, ensuring that an LDES member is processed only once.

<p align="center"><img src="/assets/images/State.png" width="60%" text-align="center"></p>
