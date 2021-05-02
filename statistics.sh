#!/bin/bash

# Statistics about the projects.
total_number_project=$(cat general_H2020_project_info.csv | sed 1,1d | wc -l)
number_project_with_del=$(cat deliverables_URL_per_project.txt | sed 1,1d | cut -d ';' -f 1 | sort -u | wc -l)
number_project_without_del=$(cat project_without_deliverables_in_Europa.txt | sed 1,1d | wc -l)
number_of_deliverable=$(cat deliverables_URL_per_project.txt | sed 1,1d | wc -l)

# Statistics about the deliverables.
number_of_words_in_deliverables=$(cat occurrence.csv | cut -d ';' -f 10 | sed 1,1d | awk '{sum+=$1} END {OFMT="%f"; print sum}')
number_of_pages_in_deliverables=$(cat occurrence.csv | cut -d ';' -f 11 | sed 1,1d | awk '{sum+=$1} END {OFMT="%f"; print sum}')
number_of_bytes_in_deliverables=$(cat occurrence.csv | cut -d ';' -f 12 | sed 1,1d | awk '{sum+=$1} END {OFMT="%f"; print sum}')

# Counting the occurrences.
total_number_of_mentions_osm=$(cat occurrence.csv | cut -d ';' -f 4 | sed 1,1d | awk '{sum+=$1} END {print sum}')
total_number_of_mentions_seamap=$(cat occurrence.csv | cut -d ';' -f 5 | sed 1,1d | awk '{sum+=$1} END {print sum}')
total_number_of_mentions_gmaps=$(cat occurrence.csv | cut -d ';' -f 6 | sed 1,1d | awk '{sum+=$1} END {print sum}')
total_number_of_mentions_bing=$(cat occurrence.csv | cut -d ';' -f 7 | sed 1,1d | awk '{sum+=$1} END {print sum}')
total_number_of_mentions_baidu=$(cat occurrence.csv | cut -d ';' -f 8 | sed 1,1d | awk '{sum+=$1} END {print sum}')

# Combining the various cartographic services.
number_project_having_1_osm=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4 | awk -F';' '{if ($2>0) print $1}' | sort -u | wc -l)
number_deliverable_having_1_osm=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4 | awk -F';' '{if ($2>0) print $0}' | wc -l)
number_deliverable_having_osm_gmaps=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4,6 | awk -F';' '{if ($2>0 && $3>0 ) print $0}' | wc -l)
number_deliverable_having_osm_bing=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4,7 | awk -F';' '{if ($2>0 && $3>0 ) print $0}' | wc -l)
number_deliverable_having_osm_gmaps_bing=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4,6,7 | awk -F';' '{if ($2>0 && $3>0 && $4>0 ) print $0}' | wc -l)
number_deliverable_having_something=$(ls -l ./textual_deliverable/*.txt | wc -l)

# A deeper look at Open Sea Map.
number_deliverable_having_1_seamap=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,5 | awk -F';' '{if ($2>0) print $0}' | wc -l)
number_deliverable_having_osm_seamap=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4,5 | awk -F';' '{if ($2>0 && $3>0 ) print $0}' | wc -l)

# A bit of context…
number_of_deliverable_with_poi_without_catrographic=$(cat occurrence.csv | sed 1,1d | awk -F';' 'BEGIN {sum=0} {if ($4==0 && $5==0 && $6==0 && $7==0 && $8==0 && $9>0) sum+=1} END {print sum}')

# Estimate the EU money involved by taking the EU investment for each project having at least one OSM mention in one of its deliverables
eu_money_involved_osm=$(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1,4 | awk -F';' '{if ($2>0) print $1}' | sort -u | \
			    while read -r id ; do
				grep $id general_H2020_project_info.csv | cut -d ';' -f 5
			    done | awk '{sum+=$1} END {print sum}'
		     )


echo "-----------------------------------------------------"
echo "-------------------- STATISTICS ---------------------"
echo ""

echo "General information:"
echo "- Number of distinct H2020 projects reviewed: $total_number_project"
echo "- Number of these having deliverables: $number_project_with_del"
echo "- Number of projects without deliverables in Europa base: $number_project_without_del"
echo "- Total number of deliverables: $number_of_deliverable, totalling $number_of_words_in_deliverables words spread over $number_of_pages_in_deliverables pages, and representing $number_of_bytes_in_deliverables bytes downloaded (i.e. ~$(echo "$number_of_bytes_in_deliverables / 1073741824" | bc)GB)"
echo""

#echo "In all these deliverables, there are:"
echo "Among these deliverables, we reviewed $(cat occurrence.csv | sed 1,1d | wc -l) of them (from $(cat occurrence.csv | sed 1,1d |cut -d ';' -f 1 | sort -u | wc -l) projects), and there are:"
echo "- Number of OSM mentions: $total_number_of_mentions_osm"
echo "- Number of Open Sea Map mentions: $total_number_of_mentions_seamap"
echo "- Number of Google Maps mentions: $total_number_of_mentions_gmaps"
echo "- Number of Bing Maps mentions: $total_number_of_mentions_bing"
echo "- Number of Baidu Maps mentions: $total_number_of_mentions_baidu"
echo ""

echo "More precisely, there are:"
echo "- $number_deliverable_having_1_osm distinct deliverables mentioning OSM (over $(cat occurrence.csv | sed 1,1d | wc -l))"
echo "- $number_project_having_1_osm distinct projects mentioning OSM (over $(cat occurrence.csv | sed 1,1d | cut -d ';' -f 1 | sort -u | wc -l))"
echo "- a total of $number_deliverable_having_something deliverables which mentioned at least one of the searched items"
echo ""

echo "Regarding Open Sea Map itself, which is mentioned $total_number_of_mentions_seamap, there are:"
echo "- $number_deliverable_having_1_seamap distinct deliverables mentioning it"
echo "- $number_deliverable_having_osm_seamap deliverables mentioning both OSM and Open Sea Map"
echo "(This can help to know how connected to OSM is the Open Sea Map initiative.)"
echo ""

echo "Interestingly, there are $number_of_deliverable_with_poi_without_catrographic deliverables which mention \"point of interest\" without referring to osm or to any cartographic service."
echo ""

echo "In terms of cross occurrences, there are:"
echo "- $number_deliverable_having_osm_gmaps deliverables mentioning both OSM and GoogleMaps"
echo "- $number_deliverable_having_osm_bing deliverables mentioning both OSM and Bing Maps"
echo "- $number_deliverable_having_osm_gmaps_bing deliverables mentioning OSM, GoogleMaps and Bing Maps"
echo ""

echo "Practically, these projects involving (at least) one mention of OSM represent a total of €$eu_money_involved_osm of public European money!"
echo "(Obviously, this sums the complete funds given to the projects…)"

echo ""
echo "-----------------------------------------------------"
echo "Computed on: $(date)"
echo "-----------------------------------------------------"

exit 0 ;
