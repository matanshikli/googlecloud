#!/bin/bash

space="=========================================="
sudo echo " welcome gcloud instances UI,"
echo $space

echo "Please select action to do "

echo $space

# select varName in List_instances  Delete_instances  Create_instance

# do
# case $varName in 
#     List_instances)
#         sudo gcloud compute instances list break;; 
#     Delete_instances)
#         sudo bash /Users/matanshikli/Desktop/gcloudui/list/.delete.sh break;;
#     Create_instance)
#         sudo bash /Users/matanshikli/Desktop/gcloudui/createvm/.createvm.sh break;;
#     *)
#         echo "Error select option 1..3";;
    
# esac            
# done

select tree in List_instances  Delete_instances  Create_instance 
do
break
done

if [ "$tree" == "List_instances" ]; then
  
   sudo gcloud compute instances list

  elif [ "$tree" == "Delete_instances" ]; then
  
  sudo bash "$PWD"/list/.delete.sh

    elif [ "$tree" == "Create_instance" ]; then
  
   sudo bash "$PWD"/createvm/.createvm.sh

 else
 echo "Error, please pick option only from the promat options "

fi  
echo $space

echo "Done, aboarding "