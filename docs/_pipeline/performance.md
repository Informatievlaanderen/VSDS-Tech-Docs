---
title: Performance
layout: home
nav_order: 6
---

# Performance
The [LDES Server](https://informatievlaanderen.github.io/VSDS-LDESServer4J/) and [LDIO Workbench](https://informatievlaanderen.github.io/VSDS-Linked-Data-Interactions/) are components for publishing data as LDES. They are available as [docker images](https://hub.docker.com/) that can be deployed locally or in the cloud using any container technology such as docker compose, kubernetes, or similar mechanism provided by cloud providers.

How you size the docker containers towards available CPU and memory impacts the performance of these components. Depending on your specific needs you will have to use more or less CPU and/or memory to alow your specific data sets to be ingested slower or faster into the LDES Server's database. Likewise, you need to balance these sizes for the amount of data you have and the number of clients that will be requesting this data. It is very difficult to predict the best sizes for CPU and memory usage in any particular case, especially if data sets are added or removed.

We defined and executed a number of performance tests to measure how fast these components work given some limitations in order to have a base line that can be used for sizing your particular setup.

## LDES Server Performance
The LDES Server allows to ingest the members of a data set (LDES), stores them in a database and allows to retrieve the members in a partitioned way (view). The way the LDES server is designed, these three features are decoupled from one another. That is, the ingesting & storing happens immediately upon data reception, while the partitioning happens as a background task. Once the data is processed by this job it is available for retrieval.

Depending on your data set you may first ingest all members by only defining a LDES without any views and than defining one or more views to partition the data set and make it available for retrieval. Note that without a view, the data set cannot be retrieved. Alternatively, you can define the view(s) before ingesting the members resulting in the data set being partitioned (in the background) while ingesting. For data sets that do not change (e;g. historical data sets), it depends on how fast after ingest the data set should be available: you may choose to fragment the data set during ingest or only after the data set is ingested. For fast moving data sets we recommend to ingest and partition in parallel to ensure the data set is available as soon as possible.

In order to test the server's performance we defined a [test plan](#what---test-plan), setup a controlled [test environment](#where---test-environment), created a number of [tests](#how---test-method) and executed these tests while collecting some basic statistics.

### TL;DR
Recommendations:
* make sure to allocate enough memory to the server to allow ingesting fast moving data to the same or different data set in parallel at a higher rate
* define all the required views before ingesting your data as it is faster to fragment all the views at once
* set the page size for a view to an order of magnitude of thousands to ten thousands of triples to have the highest possible fragment retrieval rate

If you only care about the numbers, you can skip the following sections and find the results [below](#results).

### What and why? - Test Plan
Data sets come in all shapes and sizes, some are small while other are huge and some are fast, slow or even non-moving. Obviously, this impacts how fast you need to be able to ingest and store the data. We do our tests with a data member of about 30 triples (the OSLO traffic dat model).

As said, the ingesting and storing runs separately from the partitioning (fragmentation) and we can configure the system in such a way that it does these two tasks either separately or together. So, we measure the ingest speed and the fragmentation speed both sequentially and in parallel. In addition, as the LDES server can accept multiple HTTP connection at the same time we also measure the effect of ingesting data from one vs. multiple clients/pipelines.

For the partitioning performance measuring we vary on the number of views to measure the impact of multiple simultaneous fragmentations. As there are multiple types of fragmentation (i.e. simply paged, geospatial & time-based) we measure the difference in speed of these types so you know the impact and can choose how and when to offer a(n additional) view on the data set.

When creating a view you need to specify the number of members that each fragment will contain. The optimal amount will vary on the size of your members (number of linked data triples) as this will impact the size of a fragment and therfore the amount of time needed when returning the fragment and the time needed to actually read (parse) the fragment. In order to determine the optimal member count (for a specific use case) we measured the retrieve (fetch) time needed varying on the number of members in a fragment.

### Where? - Test Environment
As said, the LDES components are available as docker images and can therefore be deployed locally or in a cloud environment. We used the local environment for test development and to simulate a high-end deployment environment. We used a typical cloud environment as a mid-range deployment environment. Finally, we also ran the tests in a very small physical environment. This allowed us to measure the impact of the differently sized environments.

For all test enviroments we used the same sizing for the actual containers:

|sizes|initial|limit|
|-|-|-|
|cpu (virtual)|0.5|3.0|
|memory (GiB)|0.5|2.0|

> **Note**: in the cloud environment we had to increase the maximum memory to 3 GB for one test (retrieve 10000 members/page) to avoid running out of java heap space.

#### High-End Test Environment
To simulate a high-end deployment environment we used a MacBook Pro (Apple M2 pro with 10 cores - 6 performance + 4 efficiency) with 16GiB physical RAM. Using docker compose we ran all our services locally on this system in their own private network.

#### Mid-range Test Environment
For a typical deployment environment we used a cloud environment where we had two separate clusters: one for the (postgres) database and one for all our other services. The database cluster is a single node [t4g.medium instance](https://aws.amazon.com/rds/instance-types/)(2 vCPU and 4 GiB system), while the other services used a dual node [m5.2xlarge instance](https://aws.amazon.com/ec2/instance-types/m5/) (8 vCPU and 32 GiB system). We used ArgoCD and terraform for the deployment in this environment.

### How? - Test Method
To write and run the actual tests we used [JMeter](https://jmeter.apache.org/). In addition, we created and used a small management tool ([JMeter Runner](https://github.com/Informatievlaanderen/jmeter-runner)) to schedule tests, cancel or delete tests, follow up the running tests and view tests results.

Each test ingests 100K members using a number of pipelines and partitions the data set using one or more views. A test produces a stats.xml file containing the base measurements in addition to the standard report generated automatically by JMeter. This stats.xml file allows us to capture and report measurements on the background (fragmentation) tasks as well.

We run the following tests in seven test runs to have a few statistical values, i.e. min, max and average:
* calculate ingest speed using 1, 2 and 4 pipelines - sequentially (without partitioning by only seeding the LDES definition)
* calculate fragmentation speed using 1, 2 and 4 simple paged views - sequentially (after sequential ingest)
* calculate fragmentation speed of geospatial (by-location) and time-based (by-time) using 1 view
* calculate ingest and fragmentation speed using a combination of 1, 2 & 4 pipelines vs. 1, 2 & 4 views (e.g. 2 pipelines towards 4 views) - parallel ingest & partitioning
* calculate fetch speed using 10, 100, 250, 500, 1000, 2500, 5000 & 10000 members per page - no parsing/reading, measures only the fragment creation and retrieval

The test definitions and the instructions to run these tests locally can be found [here](https://github.com/Informatievlaanderen/VSDS-LDES-performance-testing/tree/main/load-testing/server) while the docker compose file and related files can be found [one level up](https://github.com/Informatievlaanderen/VSDS-LDES-performance-testing/tree/main/load-testing).

### Results
All results show the average values of all test runs in members per second (rounded to the nearest tens). For details we would like to refer you to [the results source](https://github.com/Informatievlaanderen/VSDS-LDES-performance-testing/blob/main/load-testing/server/results.xlsx). We have tested our reference image ([3.6.0](https://hub.docker.com/r/ldes/ldes-server/tags)) of the LDES Server.

#### Sequential Ingest Speed Test

||High-end|Mid-range|
|-|-:|-:|
|1 pipeline|2100|890|
|2 pipelines|3780|1620|
|4 pipelines|4160|1850|

> **Note** that we see a performance increase of 80% to 100% for the high-end and even up to 110% increase for the mid-range environment when multiple pipelines are used on a system which has enough cores.

The original target ingest rate of 100K members/minute is feasible and even largely surpassed with 250K members/minute given a high-end system using multiple pipelines. This means that theoretically you can ingest 15M members/hour, which is 360M members/day and boils down to more than a dazzling 130 billion members/year! We have not tried this but we currently do have installations with more than 70M members.

**Conclusion**: the LDES Server ingest task is fast enough given enough resources (memory) so you can use multiple pipelines to ingest the same or different data set at the same time.

#### Sequential Fragment Speed Test

||High-end|Mid-range|
|-|-:|-:|
|1 view|1920|650|
|2 views|1750|550|
|4 views|810|380|

> **Note** that the performance increase is 80% & 70% (high-end case) and 70% & 130% (mid-range case) for 2 resp. 4 views at once because more work is done at the same time.

Although the raw numbers seem to indicate a performance loss, the work done for 2 and 4 views is double resp. quadruple. So, there is in fact an increase in performance when doing the fragmentation for the views in parallel vs. if we would have to fragment multiple views sequentially.

**Conclusion**: it is faster to fragment all the views at once, so if you know that you will need multiple views, you can define them all before ingestion.

#### Parallel Ingest Speed Test

|||High-end|Mid-range|
|-|-|-:|-:|
|1 pipeline|1 view|2020|810|
|2 pipelines|1 view|3630|1510|
|4 pipelines|1 view|4300|1780|
|1 pipeline|2 views|1680|740|
|2 pipelines|2 views|2690|1410|
|4 pipelines|2 views|3380|1640|
|1 pipeline|4 views|990|630|
|2 pipelines|4 views|1760|1180|
|4 pipelines|4 views|2070|1300|

> **Note** that the ingest speed is typically slower if done in parallel with the fragmentation task, with the ingest speed decreasing more when fragmenting multiple views. The performance decrease is up to 55% for high-end systems when ingesting using a single pipeline and fragmenting 4 views. For a mid-range system this is only 30%.

**Conclusion**: allthough the ingest speed is overall higher than the fragmentation speed, it still may be a good choice to ingest in parallel if possible.

#### Parallel Fragmentation Speed Test

|||High-end|Mid-range|
|-|-|-:|-:|
|1 view|1 pipeline|1860|560|
|2 views|1 pipeline|1410|470|
|4 views|1 pipeline|710|320|
|1 view|2 pipelines|1840|560|
|2 views|2 pipelines|1370|470|
|4 views|2 pipelines|730|330|
|1 view|4 pipelines|1760|560|
|2 views|4 pipelines|1360|470|
|4 views|4 pipelines|700|330|

> **Note** that the number of pipelines does not affect the fragmentation speed, i.e. the numbers are almost identical for the same number of views. This is the case because the fragmentation process runs as a background task independant from the ingestion process.

> **Note** that the fragmentation speed is also slower than the ingest speed when done in parallel but it is less noticable with a decrease of up to 25% for a high-end system and only up to 15% for a mid-range one.

**Conclusion**: because the partitioning is not that much slower when done in parallel we recommend to do the ingest and fragmentation in parallel. If really needed, you can do them sequentially as described [above](#ldes-server-performance).

#### Fetch Speed Test

||High-end|Mid-range|
|-|-:|-:|
|10 mpp|2510|1030|
|100 mpp|3670|1690|
|250 mpp|3590|1760|
|500 mpp|3400|1760|
|1000 mpp|3050|1680|
|2500 mpp|2870|1500|
|5000 mpp|2740|1430|
|10000 mpp|2610|1380|

> **Note** that the optimal fetch speed is 250 members per page (for a linked data model of about 30 triples). Depending on the system sizing we see that 100 members/page and 500 members/page give comparable results. Using a small page size (i.e. 10 mpp) is 30% - 40% slower. Using larger page size (> 1000 mpp) typically decreases the fetch rate by 15% - 30 %.

**Conclusion**: the ideal page size is 100 mpp - 1000 mpp for a 30 triples data model meaning that the ideal fragment size is order of magnitude of thousands to ten thousands of triples. You may need to experiment a bit by creating a few views with a different page member count, but the usual default that we recommend is 250 mpp.

## LDES Client Performance
> Not yet available
