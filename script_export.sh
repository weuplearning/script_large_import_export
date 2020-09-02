#!/bin/bash

#************1************
#This script allow you to export a large number of course (edx courses) trough curl,
#it creates a folder named "courses",
#loop trough an array of id you provide named "coursesIdArray" and use curl on eport endpoint provided by edx platform




echo "***********************Starting course exporting script***********************"




#Array of course id to be exported
coursesIdArray=('course-v1:Airbus+TE101+2020_T2' 'course-v1:formationenligne-thconseil+aph-ffh+01')

#Token for authentication, using a session already pending
sessionid=""
csrftoken=""
sessionid2=""


#Check if folder named "courses" exist and go inside, if not create one
if [ -d "./courses" ]
then
    echo "Folder named courses exist, going in"
    echo "Goind in folder courses"
    cd ./courses
else
    echo "Folder named courses does not exist"
    echo "Creating folder courses"
    mkdir ./courses
    echo "Goind in folder courses"
    cd ./courses
fi

echo "Start loop"
#Looping trough the array of id for curl
for i in ${coursesIdArray[*]}; do
   echo "Start export for $i"

   curl 'https://studio.the-mooc-agency.com/export/'$i'?_accept=application/x-tgz' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Sec-Fetch-User: ?1' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: navigate' -H 'Referer: https://studio.the-mooc-agency.com/export/'$i -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' -H 'Cookie: edxloggedin=true; sessionid='"$sessionid"'; csrftoken=$csrftoken; sessionid='"$sessionid2"'' --compressed -o $i'.tar.gz';
   echo "$i is exported"
done

echo "**********************************End of export**********************************"
