#!/bin/bash

echo "#################################"
echo "####### Starting logsave ########"
echo "#################################"

# create a key in your ~/.ssh folder [insert keycommand]
# add it to each server with ssh-copy-id remoteusername@server_ip_address 
# if there is already a directory named authorized_keys, delete it and run the command again
#C2HOST1="HIDDEN"
#C2HOST2="HIDDEN"
#C2HOST3="HIDDEN"
#P2HOST1="HIDDEN"
#P2HOST2="HIDDEN"
#O2HOST1="HIDDEN"
#O2HOST2="HIDDEN"
#O2HOST3="HIDDEN"

YEAR=`date +%Y`
MONTH=`date +%m`
#DAY='date +%d'

APPLOGPATH=HIDDEN
HOMELOGPATH=HIDDEN


#Scopy copies first 7 days of the current months log files to local folder
function Scopy() {
	
	#create directories for logs in local 
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	#`mkdir -p $HOMELOGPATH/HIDDEN`
	
	declare -a HOSTS=("HIDDEN" "HIDDEN" "HIDDEN" "HIDDEN" "HIDDEN" "HIDDEN" "HIDDEN" "HIDDEN")
	REGION="C2"
	SERVER="s1"
	
	SERVERLIMIT=3
	
	for CURRENTHOST in ${HOSTS[@]}
	do
	
		SERVERCOUNT=1
	
		case "$CURRENTHOST" in
			
			"HIDDEN")  # scan for servers 1,2
				REGION="P2"
				SERVERCOUNT=1
				SERVERLIMIT=2			
			;;
			"HIDDEN")  # scan for servers 2,3,4
				SERVERCOUNT=2
				SERVERLIMIT=4
			;;
			"HIDDEN")
				REGION="O2"  # scan for servers 1,2
				SERVERCOUNT=1
				SERVERLIMIT=2
			;;
			"HIDDEN")  # scan for servers 2,3,4
				SERVERCOUNT=2
				SERVERLIMIT=4
			;;
			"HIDDEN")  # scan for servers 3,4,5,6  (skip 4 later in loop)
				SERVERCOUNT=3
				SERVERLIMIT=6
			;;
			*)  # default condition for all C2 Hosts
				SERVERCOUNT=${CURRENTHOST: -1} # set servernumber = last digit of CURRENTHOST
				SERVERLIMIT=$SERVERCOUNT
			;;
		esac
		
		while [ $SERVERCOUNT -le $SERVERLIMIT ] # Loop through servers based on Region
		do 
			
			# skip server 4 for HIDDEN - (no applogs there)
			if [ $CURRENTHOST = "HIDDEN" -a $SERVERCOUNT -eq 4 ]
				then
					((SERVERCOUNT++))
			fi
		
			SERVER="s$SERVERCOUNT"
		
			LOGDAY=1
			while [ $LOGDAY -lt 8 ] #Loop through days 1-7
			do 	
			
				echo "$REGION - $CURRENTHOST - $SERVER - $LOGDAY"
				echo "SCOUNT = $SERVERCOUNT     SLIMIT = $SERVERLIMIT"
				
				#check if file exits and block output
				if ssh $USERNAME@$CURRENTHOST ls $APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY \> /dev/null 2\>\&1 
					then
						# secure copies HIDDEN logs to local path
						# @@@ scp $USERNAME@$CURRENTHOST:$APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH/$REGION/$CURRENTHOST/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY
						scp -l 8192 $USERNAME@$CURRENTHOST:$APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH
					
					else
						echo "Log Not Found: $REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY"
				fi
				
				if ssh $USERNAME@$CURRENTHOST ls $APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY \> /dev/null 2\>\&1 
					then
						# secure copies of HIDDEN logs to local path 
						# @@@ scp $USERNAME@$CURRENTHOST:$APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH/$REGION/$CURRENTHOST/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY
						scp -l 8192 $USERNAME@$CURRENTHOST:$APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH
				elif ssh $USERNAME@$CURRENTHOST ls $APPLOGPATH/HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY \> /dev/null 2\>\&1 
					then # found logs without region name - (for O2)
						# @@@ scp $USERNAME@$CURRENTHOST:$APPLOGPATH/HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH/$REGION/$CURRENTHOST/HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY
						scp -l 8192 $USERNAME@$CURRENTHOST:$APPLOGPATH/HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH
				elif ssh $USERNAME@$CURRENTHOST ls $APPLOGPATH/HIDDEN/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY \> /dev/null 2\>\&1 
					then # found log in alternate directory - (for P2)
						# @@@ scp $USERNAME@$CURRENTHOST:$APPLOGPATH/HIDDEN/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH/$REGION/$CURRENTHOST/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY
						scp -l 8192 $USERNAME@$CURRENTHOST:$APPLOGPATH/HIDDEN/$REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH
				else
					echo "Log Not Found: $REGION-HIDDEN-"$SERVER"_HIDDEN_perf.log.$YEAR-$MONTH-0$LOGDAY"
				fi
				
				# if region = P2... do HIDDEN
				
				if [ $REGION = "P2" ]
					then
						if ssh $USERNAME@$CURRENTHOST ls $APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY \> /dev/null 2\>\&1 
							then
								# @@@ scp $USERNAME@$CURRENTHOST:$APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH/$REGION/$CURRENTHOST/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY
								scp -l 8192 $USERNAME@$CURRENTHOST:$APPLOGPATH/$REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY $HOMELOGPATH
							else 
								echo "Log Not Found: $REGION-HIDDEN-"$SERVER"_HIDDENPerf.log.$YEAR-$MONTH-0$LOGDAY"
						fi
				fi
			
			
				((LOGDAY++))
			done # end of Day Loop
			((SERVERCOUNT++))
		done  # end of Server Loop
	done # end of Host Loop

}

Scopy #start function

echo "#################################"
echo "######## Ending logsave #########"
echo "#################################"

exit 0