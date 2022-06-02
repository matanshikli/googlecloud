#!/bin/bash

  #files
  Log_file=$PWD/list/.log.txt
   faillog=$PWD/list/.faillog.txt

  Temp_file=$PWD/list/.temp.csv
  Temp_file2=$PWD/list/.temp2.csv
 
 space="=========================================="

#def log functaion
sendlog () {
echo $space
date
echo "Delete log:"
echo "instance Name:" $Name
echo "instance:" $Zone
echo "instance Type" $MACHINE_TYPE
echo "Internal IP:"$INTERNAL_IP
echo "External IP:" $EXTERNAL_IP
echo $space
}

#def select functaion
#select from a list and break all the data from the list
selectin () {
  select Deletevm in $(cat $Temp_file2)
        do
        Name=$( echo $Deletevm | grep "NAME:"  )
        Name="${Name#*_}"
        Name="${Name%%_*}"

        Zone="${Deletevm##*"_ZONE:"}"
        Zone="${Zone#*_}"
        Zone="${Zone%%_*}"

        MACHINE_TYPE="${Deletevm##*"_MACHINE_TYPE:"}"
        MACHINE_TYPE="${MACHINE_TYPE#*_}"
        MACHINE_TYPE="${MACHINE_TYPE%%_*}"
       
        INTERNAL_IP="${Deletevm##*"_INTERNAL_IP:"}"
        INTERNAL_IP="${INTERNAL_IP#*_}"
        INTERNAL_IP="${INTERNAL_IP%%_*}"
       
        EXTERNAL_IP="${Deletevm##*"_EXTERNAL_IP:"}"
        EXTERNAL_IP="${EXTERNAL_IP#*_}"
        EXTERNAL_IP="${EXTERNAL_IP%%_*}"
        
        break 
        done 
      echo $space
}

#list instances and AWK to make all instance on a line
  echo "Listing instances"
  echo $space

  sudo gcloud compute instances list | tee $Temp_file
  
  awk 'NR%8{printf "%s ",$0;next;}1' $Temp_file | sed -e 's/ /_/g' > $Temp_file2


echo $space

echo "select instance to delete:"
echo $space

selectin

  echo $space
  echo "Do you sure you want to delete?? :"  $Name
      echo $space

  select yesorno in No Yes
        do 
        break 
        done 
  
   if [ "$yesorno" == "Yes" ]; then
  
  sendlog >>$Log_file
  echo "Deleting" $Name
  gcloud compute instances delete $Name --zone $Zone | tee -a $Log_file
  echo $space

  else 
  
  echo "ABORAD" 
    echo "Faillog" >> $faillog
    echo "DIDNT delete">> $faillog
    sendlog>>$faillog
    echo "DIDNT delete">> $faillog
    echo $space


  fi  

  rm -rf /Users/matanshikli/Desktop/gcloudui/list/.temp.csv 
  rm  /Users/matanshikli/Desktop/gcloudui/list/.temp2.csv
  