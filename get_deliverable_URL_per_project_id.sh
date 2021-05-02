#!/bin/bash

echo "id" > project_without_deliverables_in_Europa.txt
echo "id;url;title" > deliverables_URL_per_project.txt

cat general_H2020_project_info.csv | \
    sed 1,1d | \
    while IFS=';' read -r id acronym title totalCost ecMaxContribution startDate endDate duration ; do
	#echo "https://cordis.europa.eu/project/id/$id/results" ;
	#id="645833";	
	deliverable=$(curl "https://cordis.europa.eu/project/id/$id/results" | \
	    tr '<' '\n' | \
	    grep -i -A 500 deliverable | \
	    grep -i href | \
	    grep ec.europa.eu | \
	    awk -v id="$id" -F'href=|> ' 'OFS=";" {print id,$2,$3}' | \
	    sed 's/amp;//g')
	if [ ! -z "$deliverable" ]
	then
	    echo "$deliverable" >> deliverables_URL_per_project.txt
	else
	    echo "$id" >> project_without_deliverables_in_Europa.txt
	fi
done ;

exit 0 ;
