#!/usr/bin/bash

# - FastCount.sh 
# - Matthew Muldoon
# - Created March 2019
#
# Script is run nightly on HIDDEN to sum total number of print lines per plan for the previous day.
# 
# Output : 
# 	csv file in HIDDEN  -->  PL-Month/Day/Year.Hour:Minute.csv
#	format:  planCode,totalApproved,totalDenied 

echo "#####################################"
echo "|||||    Starting printLine     |||||"
echo " "

YESTERDAY=$(TZ="EST+24" ; date +%Y%m%d)
#YESTERDAY=$((`date +%Y%m%d` -1))
#echo "yesterday is $YESTERDAY"
TIME=`/usr/bin/date +%H:%M`
#echo "time is $TIME"

#CSVFILE="PL-$YESTERDAY.$TIME.csv"

HOST="HIDDEN"
USERNAME="HIDDEN"

EOBPATH=HIDDEN
SHPATH=HIDDEN #path to home on server

function Go() {
# method given plancode and ATOTAL and DTOTAL 
	
	PCODE="$1"
	ASUM="$2"
	DSUM="$3"
	FLE="$4"
	
	#echo "$PCODE,$ASUM,$DSUM"	
	printf "%s\n$PCODE,$ASUM,$DSUM" >> "$SHPATH/$FLE"
}

#main function
function Begin() { 
	
	#EOBPATH="$1"
	#echo "$EOBPATH"
	
	#DAY="A20190327"  # Test
	#DAY="A$YESTERDAY"   
	
	DS=24
	while [[ $DS -le 30 ]] 
	do
		
		DAY="A201903$DS"
		CSVFILE="'$DAY'PL.csv"
		echo "$CSVFILE"
		
		#if finds the folder for yesterday
		if [ -d "$EOBPATH/$DAY" ]
			then
				#echo "found $DAY"
				
				
				`/usr/bin/mkdir -p $SHPATH`
				`/usr/bin/touch $SHPATH/$CSVFILE`
				printf "CSV File Created: $SHPATH/$CSVFILE \n"
				
				for PLAN in $EOBPATH/$DAY/*
				do
					ATOTAL=0
					DTOTAL=0
					VALUE=0
					
					#echo "PLAN: $PLAN"
					FAPATH=$PLAN/APP/*.txt
					for FILE in $FAPATH
					do
						#echo "APP:"
						#echo "File:  $FILE"
						if [ "$FILE" = "$PLAN/APP/*.txt" ]
						then
							#echo "Empty"					
							break
						else 
							VALUE=$( /usr/bin/wc -l < $FILE | /usr/bin/bc )
							ATOTAL=$(($ATOTAL+$VALUE))			
							#echo "ATOTAL: $ATOTAL"
							#echo "VALUE: $VALUE"
							#echo " "
						fi
											
					done
					FBPATH=$PLAN/DEN/*.txt
					for FILE in $FBPATH
					do
						#echo "DEN:"
						#echo "File:   $FILE"
						if [ "$FILE" = "$PLAN/DEN/*.txt" ]
						then
							#echo "Empty"					
							break
						else 
							VALUE=$( /usr/bin/wc -l < $FILE | /usr/bin/bc )
							DTOTAL=$(($DTOTAL+$VALUE))			
							#echo "DTOTAL: $DTOTAL"
							#echo "VALUE: $VALUE"
							#echo " "
						fi
											
					done
					
					PC="$( /usr/bin/echo "$PLAN" | /usr/bin/tail -c 4 )"
					
					Go "$PC" "$ATOTAL" "$DTOTAL" "$CSVFILE"					
					
				done
				
			echo "$CSVFILE Contents:"
			echo "$( /usr/bin/cat $SHPATH/$CSVFILE )"
				
		else
			echo "---$DAY not found : no csv created"
		fi
		
		(( DS++ ))
	done

}

Begin 

exit 0