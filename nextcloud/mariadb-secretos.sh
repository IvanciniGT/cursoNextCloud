#!/bin/bash

USERNAME=$(echo -n "usuarioBBDD" | base64)
PASSWORD=$(echo -n "password" | base64)

cat <<EOF | kubectl apply -f - 
kind:           Secret
apiVersion:     v1

metadata:
    name:       mariadb-secret
    namespace:  $NAMESPACE 
data:
    username:                       $USERNAME    
    password:                       $PASSWORD
    mariadb-root-password:          $PASSWORD
    mariadb-replication-password:   $PASSWORD
    mariadb-password:               $PASSWORD

EOF