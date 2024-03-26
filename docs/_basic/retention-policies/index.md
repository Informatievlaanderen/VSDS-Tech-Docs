---
layout: default
title: 7. Retention Policies
nav_order: 7
has_children: true
has_toc: true
---

# Retention Policies

To reduce storage fill up, it is possible to set a retention policy per view.
A retention policy has to be added together with its view.


A retention policy is a set of rules determining how long data should be kept or deleted. A retention policy can be applied to an LDES to manage the storage and availability of data objects over time.

Currently, the LDES spec defines two retention policies, a time-based an a version-based retention policy. More information about the retention policies can be found in the [spec](https://semiceu.github.io/LinkedDataEventStreams/#retention).

{: .note}
The LDES Server buildling block implements a time-based retention policy. More information can be found [here](https://informatievlaanderen.github.io/VSDS-Tech-Docs/introduction/Specification#retention-policy).


## Retention polling interval
By default, every day, the server checks if there are members that can be deleted that are not conform to the retention policy anymore.
If a higher retention accuracy is desired, or a lower one if resources are limited for example, then a respectively lower or higher retention polling interval can be set via a cron expression.

To configure this interval, please refer to the [Configuration Page.](../../how-to-run#ldes-server-config)

## Supported Retention Policies:


