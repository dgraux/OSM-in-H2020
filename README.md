OSM in H2020
============

> Analysing all H2020 open deliverables, searching for OSM (and cartographic systems)
> [https://dgraux.github.io/OSM-in-H2020/](https://dgraux.github.io/OSM-in-H2020/)

Goal
----

The overall goal of this project is to have a look at the involvement
of OpenStreetMap within the publicly funded H2020 European
projects. To do so, this project systematically reviews **all** the
H2020 publicly available deliverables in order to check if they
involve OpenStreetMap or other cartographic services such as Google
Maps, Bing Maps or Baidu Maps. These high-level observations allow to
have an idea of how H2020 projects rely on the OSM initiative to
achieve their purposes.

Steps to reproduce
------------------

The complete project can be reproduced running **4** commands and a
fifth one allows to compute basic statistics on the final
results. (These were computed in April 2021 and, as the scripts rely
on parsing external sources _inter alia_ the European H2020 one, they
might need slight tweaks in the future...)

```
time bash collect_XML_info_for_all_projects.sh > log_collect_XML.txt 2>&1
time bash extract_H2020_general_info_for_all_projects.sh > general_H2020_project_info.csv
time bash get_deliverable_URL_per_project_id.sh
time bash search_deliverable.sh > occurrence.csv

bash statistics.sh
```

Also, be aware, that with a regular laptop (~16GB of memory and 8
cores) with no multi-threading, the overall process might take a
while. Here are some times:

1. To collect XML info: 141m28.625s
2. To extract H2020 info: 12m35.351s
3. To obtain the deliverable's URLs: 2020m3.674s
4. To download, crawl and analyse the deliverables: 392m42.457s (For the first 6000 deliverables...)

Furthermore, it's worth mentioning that the scripts rely on some
commands which might not be *by default* on systems: `curl`,
`pdfgrep`, `pdfinfo` and `pdftotext`.

Analyses
--------

Here are the results obtained once the aforementioned set of commands
is finished. (For further analyses, you may have a look at the
associated Web page, available from:
[https://dgraux.github.io/OSM-in-H2020/](https://dgraux.github.io/OSM-in-H2020/).)

```
$> bash statistics.sh
-----------------------------------------------------
-------------------- STATISTICS ---------------------

General information:
- Number of distinct H2020 projects reviewed: 33636
- Number of these having deliverables: 8479
- Number of projects without deliverables in Europa base: 25157
- Total number of deliverables: 92612, totalling 1017440633 words
  spread over 5336481 pages, and representing 288038272361 bytes
  downloaded (i.e. ~268GB)

Among these deliverables, we reviewed 92612 of them (from 8479
projects), and there are:
- Number of OSM mentions: 18595
- Number of Open Sea Map mentions: 312
- Number of Google Maps mentions: 2801
- Number of Bing Maps mentions: 226
- Number of Baidu Maps mentions: 4

More precisely, there are:
- 1840 distinct deliverables mentioning OSM (over 92612)
- 651 distinct projects mentioning OSM (over 8479)
- a total of 2790 deliverables which mentioned at least one of the searched items

Regarding Open Sea Map itself, which is mentioned 312.5, there are:
- 27 distinct deliverables mentioning it
- 20 deliverables mentioning both OSM and Open Sea Map
(This can help to know how connected to OSM is the Open Sea Map initiative.)

Interestingly, there are 1796 deliverables which mention "point of interest"
without referring to osm or to any cartographic service.

In terms of cross occurrences, there are:
- 291 deliverables mentioning both OSM and GoogleMaps
- 59 deliverables mentioning both OSM and Bing Maps
- 39 deliverables mentioning OSM, GoogleMaps and Bing Maps

Practically, these projects involving (at least) one mention of OSM represent
a total of €3.84869e+09 of public European money!
(Obviously, this sums the complete funds given to the projects…)

-----------------------------------------------------
Computed on: Sat  1 May 10:03:57 IST 2021
-----------------------------------------------------
```

License
-------

Apache License version 2.0, see [LICENSE](./LICENSE) for more details.

Contact
-------

Damien Graux, Inria (France), [https://dgraux.github.io/](https://dgraux.github.io/)  
Thibaud Michel, Wemap (France), [https://tyrex.inria.fr/people/thibaud.michel/index.html](https://tyrex.inria.fr/people/thibaud.michel/index.html)

