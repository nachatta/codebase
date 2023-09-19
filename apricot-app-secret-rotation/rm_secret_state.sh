#!/bin/bash

secret_resources=$(terraform state list | grep -E "^module\.kv_app_secret\[[0-9]+\]\.azuread_application_password\.secret$")
if [ -n "$secret_resources" ]
then
      bold=$(tput bold)
      normal=$(tput sgr0)
      echo "${bold}Do you want to remove state for the following resources?${normal}"
      echo "$secret_resources"
      echo    # newline
      echo -e "\tOnly 'yes' will be accepted to approve."
      read -p $'\t'"${bold}Enter a value: ${normal}" -r
      echo    # newline
      if [[ $REPLY =~ ^yes$ ]]
      then
          echo "$secret_resources" | xargs -L1 -I addr terraform state rm addr
      fi
else
      echo "no secrets found in state"
fi