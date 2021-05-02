#!/bin/bash

echo "id;url;title;#osm;#sea_map;#GMaps;#Bing;#Baidu;Point of interest?;#Mots;#Pages;Size (bytes)"

# head -n 6000 deliverables_URL_per_project.txt | \
#    sed 1,1d | \

#tail -n +6000 deliverables_URL_per_project.txt | head -n 25000 | \

tail -n +2000 deliverables_URL_per_project.txt | head -n 300 | \
    sed 's/"//g' | \
    while IFS=';' read -r id url title ; do
	# Obtain the correct URL and open a session with cookies and stuff.
	newURL=$(curl -c cookies.txt "$url" -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:87.0) Gecko/20100101 Firefox/87.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-GB,en;q=0.5' --compressed -H 'Connection: keep-alive' | awk -F'location=' '{if ($2!="") print $2}' | tr ';' ' ' | sed 's/'"'"'//g' )

	# sleep .5
	
	# Download the deliverable. (over-writting the previous one to save space)
	curl -b cookies.txt -o deliverable.pdf "$newURL" -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:87.0) Gecko/20100101 Firefox/87.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-GB,en;q=0.5' --compressed -H 'Connection: keep-alive'

	#sleep 1
	
	# Grep the .pdf counting the occurrences of open [street|sea] map, [google|bing|baidu] maps.
	osm=$(pdfgrep -ic 'open.?street.?map|[^a-z0-9]osm[^a-z0-9]|[^a-z0-9]osm$|^osm[^a-z0-9]|^osm$' deliverable.pdf)
	seamap=$(pdfgrep -ic 'open.?sea.?map' deliverable.pdf)
	gmaps=$(pdfgrep -ic 'google.?maps|gmaps' deliverable.pdf)
	bing=$(pdfgrep -ic 'bing.?maps' deliverable.pdf)
	baidu=$(pdfgrep -ic 'baidu.?maps' deliverable.pdf)

	# Checking if there is a mention about points of interest
	poi=$(pdfgrep -ic 'point of interest|points of interest|[^a-z0-9]poi[^a-z0-9]' deliverable.pdf)
	
	# Saving the deliverable text if there are matches before, it
	# will be named: id_hash(title).txt
	if [ "$osm" -ge 1 ] || [ "$seamap" -ge 1 ] || [ "$gmaps" -ge 1 ] || [ "$bing" -ge 1 ] || [ "$baidu" -ge 1 ]
	then
	    pdftotext deliverable.pdf "./textual_deliverable/$(echo $id)_$(echo "$title" | cksum | cut -d ' ' -f 1 ).txt" ;
	fi
	
	# Meta-information about the deliverable.pdf such as number of
	# words, number of pages and the file size (check before if
	# the .pdf exists or isn't corrupted)
	wordsInDeliverable=$(pdftotext deliverable.pdf - | wc -w )
	pagesInDeliverable=$(pdfinfo deliverable.pdf | tr -d ' ' | grep "Pages:" | cut -d ':' -f 2 )
	sizeOfDeliverable=$(du -b deliverable.pdf | cut -f 1 )
	
	# Print the results together with the previous information
	echo "$id;$url;$title;$osm;$seamap;$gmaps;$bing;$baidu;$poi;$wordsInDeliverable;$pagesInDeliverable;$sizeOfDeliverable"
    done

exit 0 ;

# Eventually clean cookies.txt and deliverable.pdf
