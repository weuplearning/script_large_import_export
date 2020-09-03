#!/bin/bash

#************3************
#This script allow you to import a large number of course (edx courses) trough curl,
#It loop trough a folder containig export of course you want to import,
#Get the name of each file
#/!\ THIS FILES MUST BE NAMED AFTER THEIR ID /!\
#Split the name of each file to get the endpoint and send it trough curl




echo "***********************Starting course import script***********************"




#Token for authentication, using a session already pending
sessionid=""
csrftoken=""
sessionid2=""


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

#Looping trough the each file, get their id by their name and use curl on endpoint edx provide
for file in ./*.tar.gz
do

  #Spliting the filename to get only id
  filename="${file##*/}"
  echo "Starting import of $filename"
  IFS=':'
  read -a strarr <<< "$filename"
  filenametrimed="$(echo $filename | cut -f 1 -d '.')"
  
curl 'https://studio.preprod.amundiacademy.com/import/'$filenametrimed  -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Origin: https://studio.preprod.amundiacademy.com' -H 'X-CSRFToken: SufhxSryaj52tPa5bgawvX9jEWd5k92v' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryu8pRtChbOypKCMie' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://studio.preprod.amundiacademy.com/import/'$filenametrimed  -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' -H 'Cookie:' --data-binary $'------WebKitFormBoundaryu8pRtChbOypKCMie\r\nContent-Disposition: form-data; name="course-data"; filename=$filename\r\nContent-Type: application/gzip\r\n\r\n\r\n------WebKitFormBoundaryu8pRtChbOypKCMie--\r\n' --compressed

  echo "$filename is imported"
done

echo "**********************************End of course(s) import**********************************"
