#!/bin/bash
#

#Lista Cuentas por email_accounts para servidores MX

#Destino ficheros usuarios
DESTINO=/home/domain

#Dominios Web existentes
WEBDOMAIN=/tmp/lista_domains.txt

#Extrae Cuentas
#Parametros FICHERO DOMINIO
function ExtraeCuentas ()
{
DOMINIO=$(echo "$2" |sed 's/\(.*\)/\U\1/')
echo "Procesa ${DOMINIO}"

#Generamos ficheros
grep ":.$" $1 | sed -e 's/ //g' | awk -F: '{print $1 " cpanelpwd" }' > ${DESTINO}/$2.txt


#Añadimos Alias
if test -f /etc/valiases/$2
then
  cat  /etc/valiases/$2 | grep "@" | awk -F@ '{print $1 " cpanelalias"}'  >> ${DESTINO}/$2.txt
fi

#Contamos cuentas y actulizamos SD2
NCUENTAS=$(wc -l ${DESTINO}/$2.txt | awk '{print $1}')

}	#EndFunction


#Verifica posibles Alias
#Parametros DOMINIO_EMAIL
function IsAlias ()
{
#Verificamos Posibles Alias
DOMALIAS=$(echo $1 | awk -F. '{print $1}')
ALIAS=$(grep -i ${DOMALIAS} ${WEBDOMAIN} | grep -i -v "$1" | sed 's/\(.*\)/\L\1/')
  
#Hay alias dominio
if test ${#ALIAS} -ne 0
then
  echo "Alias  ${DOMALIAS} ---> $1"
  
  #Procesamos cada alias
  while read -r DALIAS
  do
    #echo "DALIAS ${DALIAS}"
    #echo "Alias  ${DALIAS}"
    cp ${DESTINO}/$1.txt ${DESTINO}/${DALIAS}.txt
    #echo ${DESTINO}/$1.txt ${DESTINO}/${DALIAS}.txt  
    #echo ActualizaDatos  ${DALIAS}
    ActualizaDatos  ${DALIAS}
  done <<< "${ALIAS}"
  
fi

}	#EndFunction

#################
## PRINCIPAL
################

#Ficheros con cuentas
FILES=$(ls -1 /home/*/.cpanel/email_accounts.yaml)

#Listamos cada fichero ha procesar
while read  LINEA
do

  #Listamos Todos dominios
  TDOMINIOS=$(cat ${LINEA}  | grep -E -o "^[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" | grep -v "^2.1")
 #cat ${LINEA}  | grep -E -o "[a-zA-Z0-9]+([-.]?[a-zA-Z0-9]+)*.[a-zA-Z]+$"

  #echo ${LINEA}
  #echo "${TDOMINOS}"
  #echo "============"
  
  
  while read  -r DOMEMAIL
  do

    #Verifica numero de cuentas
    FNUMEMAIL=$(echo "${LINEA}" | sed -e 's/\.yaml/_count/')
    NUMEMAIL=$(cat "${FNUMEMAIL}")

    #No es CERO
    if test "${NUMEMAIL}" -ne "0"
    then
 
      #echo ExtraeCuentas ${LINEA} ${DOMEMAIL}
      ExtraeCuentas ${LINEA} ${DOMEMAIL}

      #Tenemos Alias
      IsAlias ${DOMEMAIL}
    fi
  done <<< "${TDOMINIOS}"

done <<< "${FILES}"



exit

