#!/bin/bash

date;
for i in $(seq 1 336); do # The max number was checked on <https://cordis.europa.eu/search?q=contenttype%3D%27project%27%20AND%20(programme%2Fcode%3D%27H2020%27)&p=336&num=100&srt=Relevance:decreasing>
    wget -O raw-data/XML-data-$i.xml "https://cordis.europa.eu/search/en?q=contenttype%3D%27project%27%20AND%20(programme%2Fcode%3D%27H2020%27)&p=$i&num=100&srt=Relevance:decreasing&format=xml"
done;
date;

exit 0 ;
