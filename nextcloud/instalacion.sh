#!/bin/bash
#------------------------------------------------------------------------
#INSTALACION NEXTCLOUD ON KUBERNETES 
#------------------------------------------------------------------------
# helm plantilla -> values.yaml
# Dar de alta el repo de nextcloud
rm -rf nextcloud
rm -rf mariadb

# Aunque borre los volumenes, el directorio y sus datos reales no se borrar

echo --------------------------------------------------------
echo Repo de Nextcloud
echo --------------------------------------------------------
echo Alta del repo de nextcloud
helm repo add nextcloud https://nextcloud.github.io/helm/
echo Alta del repo de mariadb
helm repo add mariadb https://charts.bitnami.com/bitnami

helm repo update


# Descargar el chart de nextcloud para conseguir el fichero values.yaml
echo Descargamos el chart de nextcloud en su última versión,
echo con el fichero values.yaml nuevo.
helm pull --untar nextcloud/nextcloud

echo Descargamos el chart de mariadb en su última versión,
echo con el fichero values.yaml, cuyos valores puedo añadir dentro del nextcloud.yaml
echo en el apartado mariadb.
helm pull --untar mariadb/mariadb

. ./parametros.properties


# Esto solamente lo debo ejecutar cuando voy a empezar algo de cero..
# Si he intentado una instalación fallida antes
# Y no ha funcionado
if [[ $DESINSTALAR == "SI" || $BORRAR_VOLUMENES == "BORRAR_ESTOY_SEGURO" ]]; then
    echo Borramos volumenes y peticiones de volumen
    kubectl delete pvc pvc-datos-mariadb -n $NAMESPACE
    kubectl delete pvc pvc-datos-nextcloud -n $NAMESPACE
    kubectl delete pv volumen-datos-mariadb
    kubectl delete pv volumen-datos-nextcloud
fi

if [[ ! -f nextcloud.yaml ]]; then
    echo Parace que no has configurado aún nextcloud.
    echo He copiado el fichero de parametros original basjo el nombre 
    echo  nextcloud.yaml
    echo
    echo Una vez modificado, ejecuta este programa de nuevo.
    cp nextcloud/values.yaml nextcloud.yaml

    echo Recurda cambiar:
    echo     Volumen guardaremos los datos del Nextcloud: Nombre de un petición de volumen: pvc
    echo     Volumen guardaremos los datos del MariaDB: Nombre de un petición de volumen: pvc
    echo     Nextcloud-> MariaDB
    echo     MariaDB-> Crear BBDD    usuario / contraseña
    echo     Nextcloud-> usuario admin/password
    echo     Nextcloud SMTP -> usuario admin/password
    echo     Indicar en que maquinas se va a instalar nextcloud, mariadb...

    exit 0
fi


if [[ $DESINSTALAR == "SI" ]]; then
    echo --------------------------------------------------------
    echo    Empezamos desinstalación
    echo --------------------------------------------------------

    echo Desinstalamos el chart de HELM
    helm uninstall $RELEASE_NAME -n $NAMESPACE     
    
    echo Borramos el resto de recursos
    kubectl delete ns $NAMESPACE
    
    exit 0
fi
if [[ $SOLO_ACTUALIZACION == "SI" ]]; then
    echo --------------------------------------------------------
    echo    Empezamos actualización
    echo --------------------------------------------------------


    helm template nextcloud/nextcloud \
        -f nextcloud.yaml \
        -n $NAMESPACE > despliegue_actualizado.yaml

    echo Actualizamos el chart de HELM
    helm upgrade $RELEASE_NAME nextcloud/nextcloud $MODO_PRUEBA \
        -f nextcloud.yaml \
        -n $NAMESPACE     
    exit 0
fi
echo --------------------------------------------------------
echo    Empezamos instalación
echo --------------------------------------------------------


echo Crear el namespace en kubernetes
kubectl create ns $NAMESPACE

echo Creando una pvc y pv Nextcloud.
./nextcloud-volumenes.sh

echo Creando una pvc y pv MariaDB.
./mariadb-volumenes.sh

echo Creando secretos MariaDB.
./mariadb-secretos.sh

echo Creando secretos Nextcloud.
./nextcloud-secretos.sh

echo Etiquetando nodos para la instalación
./etiquetar-nodos.sh

echo Genarando fichero con el despliegue que se instalará

helm template nextcloud/nextcloud \
    -f nextcloud.yaml \
    -n $NAMESPACE > despliegue.yaml

echo Ejecutar el chart

helm install $RELEASE_NAME nextcloud/nextcloud $MODO_PRUEBA \
    -f nextcloud.yaml \
    -n $NAMESPACE
    
