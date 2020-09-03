#!/bin/bash

#************2************
#This script allow you to create a large number of course (edx courses) trough curl,
#It loop trough a folder containig export of course you want to (re)creates,
#Get the name of each file
#/!\ THIS FILES MUST BE NAMED AFTER THEIR ID /!\
#Split the name of each file and send it trough curl




echo "***********************Starting course creation script***********************"




#Token for authentication, using a session already pending
sessionid="xxxxxxxxxxxxxxxxxx:xxxxx:xxxxxxxxxxxxx:::"
csrftoken="XXXXXX"
sitefqdn="studio.XXXXXX.com"

#Check if folder named "courses" exist and go inside, if not exit with error code
if [ -d "./courses" ]
then
    echo "Folder named courses exist, going in"
    echo "Goind in folder courses"
    cd ./courses
else
    echo "Directory named courses DOES NOT exists."
    exit 9999 # die with error code 9999
fi

#Looping trough the each file, get their id by their name and use curl on endpoint edx provide
for file in ./*.tar.gz
do

  echo "Starting creation of ${file##*/}"
  #Spliting the filename to get org, number et run of the course
  filename="${file##*/}"
  filename="$(echo $filename | cut -f 1 -d '.')"
  echo "Starting creation of $filename "
  IFS=':'
  read -a strarr <<< "$filename"
  filenametrimed="${strarr[1]//[ ]/+}"
  IFS='+'
  read -a strarr <<< "${filenametrimed}"
  json='{"org":"'${strarr[0]}'","number":"'${strarr[1]}'","display_name":"1","run":"'${strarr[2]}'"}'
  echo "$json"

curl 'https://'$sitefqdn'/course/' \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Cache-Control: no-cache' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-CSRFToken: '$csrftoken \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36' \
  -H 'Content-Type: application/json; charset=UTF-8' \
  -H 'Origin: https://'$sitefqdn \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: https://'$sitefqdn'/home/' \
  -H 'Accept-Language: fr-FR,fr;q=0.9,cs;q=0.8,en-US;q=0.7,en;q=0.6,de;q=0.5' \
  -H 'Cookie: csrftoken='$csrftoken'; edxloggedin=true; experiments_is_enterprise=false; sessionid='$sessionid \
  --data-binary $json \
  --compressed

  echo "$filename is created"

  sleep 1s
done

echo "**********************************End of course(s) creation**********************************"
