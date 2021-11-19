Kubernetes
    Deployment  -> Pod1, Pod2
    Statefulset ->
    Service (DNS, balanceo de carga sobre los pods)
        ClusterIP: TODOS
        NodePort
        LoadBalancer: 1 - Proxy reverso (IngressController-nginx)
                                            Ingress
HELM charts (plantillas de despliegue) values.yaml <<<
Chart Helm NEXTCLOUD
    
Volumenes
    Cluster (Volumenes locales no nos sirve)
    Responsabilidades

PersistentVolume
PersistentVolumeClaim



Maquina 1  <  nextcloud   (nodo cluster poner una etiqueta)
    8 cores
    32 gbs
        60 Gb...
        VOLUMEN HOSTPATH
Maquina 2   jitsy
    4 cores
    8 gbs
        Poco almacenamiento
------------------------------
Maquina 1   < nextcloud
    Poco almacenamiento
Maquina 2   < nextcloud
    Poco almacenamiento

nextcloud: VOLUMEN NFS

NFS Externo 55 Gbs
-------------------------------
Kubernetes es un cluster GRANDE: 30 maquinas, 50 maquinas < EQUIPO cuya responsabilidad es la admin del cluster
                ^^^^^
Quien instala cosas en el cluster

Apps que requieren:
    Almacenamientos rápidos y confiables   CARO  ssd raid
    Almacenamiento rápido pero menos confiable
    Almacenamiento lento                    BARATO    hdd 5400 < 
    
    
    
    POD2 NGINX > PVC <> PV-
    
    
App Vestimenta - Externa:   WAR-> Contraseña BBDD  Usuario BBDD
    TOMCAT
    
    
------------------------------------------------------------------------
INSTALACION NEXTCLOUD ON KUBERNETES 
------------------------------------------------------------------------
helm plantilla -> values.yaml
Completar values.yaml
    Volumen guardaremos los datos del Nextcloud: Nombre de un petición de volumen: pvc
    Volumen guardaremos los datos del MariaDB: Nombre de un petición de volumen: pvc
    Nextcloud-> MariaDB
    MariaDB-> Crear BBDD    usuario / contraseña
    Nextcloud-> usuario admin/password
    Nextcloud SMTP -> usuario admin/password
    Indicar en que maquinas se va a instalar nextcloud, mariadb...
    
Crear una pvc y pv Nextcloud. Si tiene replicas, usan todas el mismo volumen? SI
Crear una pvc y pv MariaDB .  Si tiene replicas, usan todas el mismo volumen? NO. 
    Puede ser que necesite varias pvc y pv
Crear un secreto para el MariaDB
Crear un secreto para el Nextcloud
Crear un secreto para el Nextcloud/SMTP
Añadir etiquetas (labels) a los nodos

helm install ---> Crear muchas cosas
                        Entre ellas puedo pedir que se generen pvc y secrets en auto
helm uninstall ---> Borra todo lo que el haya creado

Los secrets y los pvc los creamos nosotros : BUENA PRACTICA 



MARIADB: Replicas:
    1 Standalone    |
    2 Replicacion   |   Chart de helm: externalDatabase: false
    -------------
    3 Galera        |   Un chart especifico de mariadb galera
                                        externalDatabase: true
                                        
                                        
nginx
balanceo

navegado ---> 1 pod

2 pods - nextcloud 1 ---> login SESION RAM
         nextcloud 2
         
         
MIGRAR A KUBERNETES:
    - Copiar los datos de nextcloud a los nuevos volumenes
    - MariaDB:
        Si instalais la misma version de mariadb, o una superior, pero en las mismas condiciones
        Copiar los ficheros del volumen 
        
        De no ser asi, teneis que hacer un export de la BBDD
        
        Crear la bbdd en otro servidor dentro de kubernetes 
        Y hacerle un import