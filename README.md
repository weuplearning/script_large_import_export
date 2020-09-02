# script_large_import_export

Repository for various script handling large number of course import/export in edx

Les différents scripts ne sont pas fonctionnel en l'état, en effet lors de l'execution du curl ne fonctionnera pas sans des données d'authentification .

Pour les récupérer utilisez chrome et son système de copie de requête dans l'onglet network (copy as curl) .

$script_create_course.sh ->
  - Remplacer le json par la var "$json"
  
$script_import_course.sh -> 
  - Remplacer le filename par la var "$filename"
  - Modifier l'adresse http https://studio.preprod.amundiacademy.com/import/ par 'https://studio.preprod.amundiacademy.com/import/'$filenametrimed
  
$script_export.sh ->
  - Modifier l'adresse http https://studio.preprod.amundiacademy.com/import/ par 'https://studio.the-mooc-agency.com/export/'$i' | Mettre à jour les adresses concerné de la même manière .
