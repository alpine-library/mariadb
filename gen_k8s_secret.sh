#!/bin/bash


usage="generate a kubernetes secret for mariadb
$(basename "$0") [-h] -n NAME [-c CRTPATH -k KEYPATH ] [-s] [-p HTPASSWDPATH]
where:
  -h           show this help text
  -n NAME      name of the secret and the generated file
  -P ROOT_PASSWORD
  -u USERNAME
  -p USERNAME_PASSWORD
  -d USERNAME_DB"



# reset in case getopts has been used previously in the shell.
OPTIND=1

# initialize our variables
name=""
root_pwd=""
user=""
user_pwd=""
user_db=""

while getopts ":hn:P:u:p:d:" opt; do
  case "$opt" in
    h)	echo "$usage"
      exit
      ;;
    n)  name=$OPTARG
      ;;
    P)  root_pwd=$OPTARG
      ;;
    u)  user=$OPTARG
      ;;
    p)  user_pwd=$OPTARG
      ;;
    d)	user_db=$OPTARG
      ;;
    \?) echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)  echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [[ -z "$name" ]]; then
  echo "please provide a name for the secret"
  exit 1
fi

if [[ -z "$root_pwd" ]]; then
  echo "please provide a ROOT_PASSWORD for the secret"
  exit 1
fi

mkdir -p tmp

echo "MYSQL_ROOT_PASSWORD=$root_pwd
MYSQL_USER=$user
MYSQL_PASSWORD=$user_pwd
MYSQL_DATABASE=$user_db
"> tmp/config

#build secret
echo "---
apiVersion: v1
kind: Secret
metadata:
  name: $name
type: Opaque
data:
  mysql-config: $(base64 -i tmp/config) "> tmp/${name}.yaml


echo "\n Your file is ready in ./tmp/, you can just do : \n"
echo "   kubectl create -f tmp/${name}.yaml \n"
echo " for upload it dont forget to destroy this directory\n\n"
