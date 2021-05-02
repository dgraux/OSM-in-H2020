#!/bin/bash

echo "id;acronym;title;totalCost;ecMaxContribution;startDate;endDate;duration" ;

for i in $(ls raw-data/); do
    # Collect info around the acronym tag.
    grep -B 1 -A 15 "acronym" raw-data/$i |\
	tr '\n' ' ' | \
	sed 's/--/\n/g' | \
	# Append a final blank line at the end.
	sed -e '$a\\\n' | \
	while read -r line; do
	    #echo +++$line ;
	    id=$(echo $line | awk -F'<id>|</id>' '{if ($2!="") print $2}')
	    acronym=$(echo $line | awk -F'<acronym>|</acronym>' '{if ($2!="") print $2}')
	    title=$(echo $line | awk -F'<title>|</title>' '{if ($2!="") print $2}')
	    totalCost=$(echo $line | awk -F'<totalCost>|</totalCost>' '{if ($2!="") print $2}')
	    ecMaxContribution=$(echo $line | awk -F'<ecMaxContribution>|</ecMaxContribution>' '{if ($2!="") print $2}')
	    startDate=$(echo $line | awk -F'<startDate>|</startDate>' '{if ($2!="") print $2}')
	    endDate=$(echo $line | awk -F'<endDate>|</endDate>' '{if ($2!="") print $2}')
	    duration=$(echo $line | awk -F'<duration>|</duration>' '{if ($2!="") print $2}')
	    if [ ! -z "$id" ]
	    then
		echo "$id;$acronym;$title;$totalCost;$ecMaxContribution;$startDate;$endDate;$duration" ;
	    fi
	done ;
done;

exit 0 ;
