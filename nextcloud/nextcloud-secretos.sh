#!/bin/bash

USERNAME=$(echo -n "admin" | base64)
PASSWORD=$(echo -n "password" | base64)
SMTP_USERNAME=$(echo -n "admin@gc.es" | base64)
SMTP_PASSWORD=$(echo -n "password-email" | base64)

cat <<EOF | kubectl apply -f -
kind:           Secret
apiVersion:     v1

metadata:
    name:       nextcloud-secret
    namespace:  $NAMESPACE 
    
data:
    username:       $USERNAME    
    password:       $PASSWORD
    smtp_username:  $SMTP_USERNAME
    smtp_password:  $SMTP_PASSWORD

EOF