#!/bin/bash

#files
Log_file=$PWD/createvm/.log.txt
Log_file_fail=$PWD/createvm/.logfail.txt
familylist=$PWD/createvm/.familylist.txt
imagelist=$PWD/createvm/.imagelist.txt
    #Switch lines if you want full Zonelist
    zonelist_ex=$PWD/createvm/.fullzonelist.txt
    zonelist=$PWD/createvm/.zonelist.txt
space="======================================================="

#def log functaion
sendlog () {
   echo "instance name: $EC2_name"
    echo "machine-kind: $EC_kind"
    echo "image project: $EC_image_proj"
    echo "image name: $EC_image_name" 
    echo "Zone: $EC_zone"
    echo "You added: $EC_extra"
}




#taking details from the user about the VM
  read -p "Instance Name: " EC2_name

    echo $space
    echo "select instance machine family (Price = n1<e2<t2d<n2d<n2)"
    echo $space

# select from a file + filter the output for the only start of the output before :
      select EC_family in $(cat "$familylist")
      do 
      EC_family=${EC_family%%:*}
      break 
      done 

    echo $space
    echo "select instance type "
    echo $space
#if to show match instance type for the instance family
       if [ "$EC_family" == "e2-" ]; then

          select EC_type in standard- micro- small- medium- highmem- highcpu-  
          do
          break 
          done 
          else 
          select EC_type in standard- highmem- highcpu-
          do
          break  
          done
          fi 
    echo $space
    echo "select vCPUs "
    echo $space

      select EC_cpu in 2 4 8 16 32 64
      do 
      EC_kind=$EC_family$EC_type$EC_cpu
      break 
      done 

    echo $space
    echo "select instance Image (1 for defalut)"
    echo $space

#select output in spilt in for to by ":" marker

      select EC_image in $(cat $imagelist)
      do
      EC_image_name=${EC_image##*:} 
      EC_image_proj=${EC_image%%:*}
      break 
      done 

    echo $space
    echo "select instance Zone"
    echo $space

echo "select Zone list"
select zone_dec in short extended
      do
      break 
      done 



if [ "$zone_dec" == "extended" ]; then

select EC_zone in $(cat $zonelist_ex)
      do
      EC_zone=${EC_zone##*:} 
      break 
      done
else
select EC_zone in $(cat $zonelist)
      do
      EC_zone=${EC_zone##*:} 
      break 
      done
fi
   
      

  echo $space

  #end of selects

  read -p "Add any extra arguments: " EC_extra 
  echo $space
  echo $space
# showing details to verify
    echo "!Going to create!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    sendlog
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "You sure want to continue???"

#select and if base on the answer to verify


          select Lastok in No Yes
          do 
          break 
          done 

          if [ "$Lastok" == "Yes" ]; then

              #send create log

              echo $space>>$Log_file
              date >>$Log_file
              
              echo 'create log'>>$Log_file
              sendlog >>$Log_file
               echo "------------------------------">>$Log_file
              echo 'gcloud log'>>$Log_file
               echo "------------------------------">>$Log_file
             

              #The commend!!!!

                    gcloud compute instances create $EC2_name \
                     --machine-type $EC_kind \
                     --image-project $EC_image_proj \
                     --image $EC_image_name  \
                     --zone $EC_zone $EC_extra | tee -a $Log_file 
            
             echo $space>>$Log_file
             exit
          else
                echo "Ending with no action"

                echo $space>>$Log_file_fail
              date >>$Log_file_fail
              echo 'NO VM was set!!!!!'>>$Log_file_fail
              sendlog >>$Log_file_fail
              echo 'NO VM was set!!!!!'>>$Log_file_fail
              echo $space>>$Log_file_fail
              exit
          fi

 