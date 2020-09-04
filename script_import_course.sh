#!/bin/bash

#************3************
#This script allow you to import a large number of course (edx courses) trough curl,
#It loop trough a folder containig export of course you want to import,
#Get the name of each file
#/!\ THIS FILES MUST BE NAMED AFTER THEIR ID /!\
#Split the name of each file to get the endpoint and send it trough curl




echo "***********************Starting course import script***********************"




#Token for authentication, using a session already pending
sessionid="xxxxxxxxxxxxxxxxxxxx:xxxx:xxxxx"
csrftoken="xxxxx"
fqdn="studio.xxxxx"
directory_of_exports="/xxxx/xxxx/xxxx"

#Check if folder named "courses" exist and go inside, if not exit with error cide
if [ -d "./courses" ]
then
    echo "Folder named courses exist, going in"
    echo "Goind in folder courses"
    cd ./courses
else
    echo "Directory named courses DOES NOT exists."
    exit 9999 # die with error code 9999
fi

i=1
#Looping trough the each file, get their id by their name and use curl on endpoint edx provide
for file in ./*.tar.gz
do
  #Spliting the filename to get only id
  filename="${file##*/}"
  echo "Starting import of $filename"
  filenametrimed="$(echo $filename | cut -f 1 -d '.')"

curl 'https://'$fqdn'/import/'$filenametrimed \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Cache-Control: no-cache' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-CSRFToken: '$csrftoken \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36' \
  -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryUotv1wxUKMTtjbxM' \
  -H 'Origin: https://'$fqdn \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: https://'$fqdn'/import/'$filenametrimed \
  -H 'Accept-Language: fr-FR,fr;q=0.9,cs;q=0.8,en-US;q=0.7,en;q=0.6,de;q=0.5' \
  -H 'Cookie: csrftoken='$csrftoken'; edxloggedin=true; experiments_is_enterprise=false; sessionid='$sessionid'; openedx-language-preference=en' \
  -F 'course-data=@'$directory_of_exports$filename \
  --compressed

  echo "$i -- $filename is imported"
  i=$((i+1))
  sleep 3s
done

echo "**********************************End of course(s) import**********************************"
