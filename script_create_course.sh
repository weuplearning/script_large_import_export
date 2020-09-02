#!/bin/bash

#************2************
#This script allow you to create a large number of course (edx courses) trough curl,
#It loop trough a folder containig export of course you want to (re)creates,
#Get the name of each file
#/!\ THIS FILES MUST BE NAMED AFTER THEIR ID /!\
#Split the name of each file and send it trough curl




echo "***********************Starting course creation script***********************"




#Token for authentication, using a session already pending
sessionid=""
csrftoken=""
sessionid2=""


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
  curl 'https://studio.preprod.amundiacademy.com/course/' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Origin: https://studio.preprod.amundiacademy.com' -H 'X-CSRFToken: SufhxSryaj52tPa5bgawvX9jEWd5k92v' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Content-Type: application/json; charset=UTF-8' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://studio.preprod.amundiacademy.com/home/' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' -H 'Cookie: ' --data-binary $json --compressed
  echo "$filename is created"
done

echo "**********************************End of course(s) creation**********************************"
