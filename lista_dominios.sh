#!/bin/bash
#

#Listar dominios WEB Cpanel 


#################
## PRINCIPAL
################

#EMAILDOMINIOS=$(cat /etc/localdomains )
DOMINIOS=$(cat /etc/userdomains | awk '{print $1}' | sed -e 's/://' )


WEBDOMAIN=/tmp/lista_domains.txt
cat /etc/localdomains  | sed 's/\(.*\)/\U\1/' >  ${WEBDOMAIN}
chmod 777 ${WEBDOMAIN}

#Procesamos cada dominio
while read -r LINE
do
  MDOMINIO=$(echo "${LINE}" | sed 's/\(.*\)/\U\1/')

  
  echo "${MDOMINIO}"
    
    
done <<< "${DOMINIOS}"

