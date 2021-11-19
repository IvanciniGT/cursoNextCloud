#!/bin/bash

cat <<EOF | kubectl apply -f - 
kind:           PersistentVolume
apiVersion:     v1

metadata:
    name:       volumen-datos-mariadb

spec:
    capacity: 
        storage: 50Gi    # NOTA: Igual que el de abajo
    
    storageClassName: mariadb
    accessModes:
        - ReadWriteOnce
    
    # NOTA: En producción montar un volumen externo:
    # P ej: un nfs:
    # nfs:
    #     server: 192.168.87.98 | mynfs.gc.es
    #     path: /carpeta /exportada/en/nfs
    hostPath:
        path: /home/ubuntu/environment/datos/kubernetes/mariadb
        type: DirectoryOrCreate
    # NOTA: Para pasar de vuestra instalación a la nueva,
    # habria que copiar lo que teneis en vuestra volumen de docker
    # A esta carpeta
---
kind:           PersistentVolumeClaim
apiVersion:     v1

metadata:
    name:       pvc-datos-mariadb
    namespace:  $NAMESPACE 

spec:
    resources:
        requests: 
            storage: 50Gi  # NOTA: Ajustar a vuestro entorno
    
    storageClassName: mariadb
    accessModes:
        - ReadWriteOnce

EOF