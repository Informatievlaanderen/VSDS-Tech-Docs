---
layout: default
title: Pagination
nav_order: 1
parent: 6. Fragmentations and pagination
---

# Pagination

By default, every Linked Data Event Stream will be partitioned, which means that the LDES server will create fragments based on the order of arrival of the LDES member. The members arriving on the LDES server are added to the first page, while the latest members are always included on the latest page.

Algorithm

1. The fragment to which the member should be added is determined.
- The currently open fragment is retrieved from the database.
- If this fragment contains members equal to or exceeding the member limit or no fragment can be found, a new fragment is created instead.
2. If a new fragment is created, the following steps are taken.
- The new fragment becomes the new open fragment and the previous fragment becomes immutable.
- This newly created fragment and the previous fragment are then linked with each other by 2 generic relationships.
- The pagenumber of the new fragment is determined based on the old fragment or is set to 1 in case of the first fragment.


