#!/bin/bash

# not needed if not CRIC
# python3 /home/user/eosc-crons/cric-info-tools/list_rses_from_cric.py -o /home/user/eosc-crons/cric-info-tools/list_rses_from_cric.txt -i /home/user/eosc-crons/cric-info-tools/disabled_rses.txt

rses=()
while read line
do
    rses+=($line) 

done < /home/rses.txt
len=${#rses[@]}

echo $rses
echo '* Assigning ENV Config Variables:'
FILE_SIZE=${FILE_SIZE:-100M}
RUCIO_SCOPE=${RUCIO_SCOPE:-test}
FILE_LIFETIME=${FILE_LIFETIME:-3600}
echo '*   FILE_SIZE = '"$FILE_SIZE"''
echo '*   RUCIO_SCOPE = '"$RUCIO_SCOPE"''
echo '*   FILE_LIFETIME = '"$FILE_LIFETIME"''

upload_and_transfer_and_delete () {
    for (( i=0; i<$len; i++ )); do

        if [ $1 != $i ]; then

            echo '*** ======================================================================== ***'

            RANDOM_STRING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
            echo '*** generated random file identifier: '"$RANDOM_STRING"' ***'
	        filename=/home/auto_uploaded_${RANDOM_STRING}_source${rses[$1]}
            did=auto_uploaded_${RANDOM_STRING}_source${rses[$1]}
            
            echo '*** generating '"$FILE_SIZE"' file on local storage ***'
            head -c $FILE_SIZE < /dev/urandom  > $filename
            echo '*** filename: '"$filename"''

            echo '*** uploading to rse '"${rses[$1]}"' and adding rule to rse '"${rses[$i]}"'' 
            rucio -v upload --rse ${rses[$1]} --lifetime $FILE_LIFETIME --scope $RUCIO_SCOPE $filename && rucio add-rule --lifetime $FILE_LIFETIME --activity "Functional Test" $RUCIO_SCOPE:$did 1 ${rses[$i]}

            #echo 'sleeping' sleep 3600 

            echo '*** removing all replicas and dids associated to from rse '"${rses[$1]}"' and adding rule to rse '"${rses[$i]}"'' 
            echo '*** testing if `rucio erase` is able to remove all the replicas too ***'
            rucio -v erase $RUCIO_SCOPE:$did

            rm -f $filename
	    fi
    done
}

echo '* RUCIO Produce Noise script START * '

for (( j=0; j<$len; j++ )); do
    upload_and_transfer_and_delete $j
done

echo '* RUCIO Produce Noise script DONE * '
