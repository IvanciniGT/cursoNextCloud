Cluster Kubernetes
    Nodo 1 - Maestro
        kubelet
        kube-proxy
        Programas propios de kubernetes:
            Scheduler
            Apiserver
            etcd
            ControllerManager
            coreDNS
    Nodo 2
        kubelet
        kube-proxy
    Nodo 3
        kubelet
        kube-proxy
    Nodo n
        kubelet     servicio (systemctl)
        kube-proxy  contenedor


Pods. Conjunto de contenedores, que:
    - Se instalan en el mismo host
    - Comparten configuración de red
    - Pueden compartir volumenes
    - Se escalan conjuntamente

Un POD es una INSTANCIA de un programa en ejecución.
Los POD habitualmente (SIEMPRE) los generamos desde una plantilla de pod:
    DEPLOYMENT      Plantilla de pod + numero de replicas... las instancias comparten volumen   
        nextcloud es un DEPLOYMENT
    STATEFULSET     Plantilla de pod + numero de replicas... pero cada instancia tendrá su propio volumen
        mariaDB es un statefulset
Todo POD que ofrezca un servicio (abra un puerto) tendrá asociado un objeto SERVICE:
    ClusterIP
        Entrada en el DNS de kubernetes
        Balanceo de carga
    NodePort
        + un puerto abierto a nivel de CADA HOST del cluster
    LoadBalancer
        + gestión automatizada de un balanceador de carga externo (on premises usamos METALLB)
        
Para comunicarnos con kubernetes usamos :
     kubectl    <VERBO> <TIPO-OBJETO> <ARGS>
                 get            pod
                 create         deployment
                 delete         statefulset
                 describe       service
                 logs           node
                 exec           configmap
                                secret
                                persistentvolume
                                persistentvolumeclaim
                                namespace
        
     dashboard << NO ESTA RECOMENDADO !
     
En Kubernetes siempre para crear cosas (configuraciones) usamos ficheros YAML
    kubectl create -f FICHERO.yaml
    kubectl delete -f FICHERO.yaml          ********
    kubectl apply -f FICHERO.yaml           ********
        Hace un create si el objeto no existe
        Intenta hacer un update si el objeto existe
     
Cualquier objeto dentro de kubernetes va identificado mediante un NOMBRE (NAME).
Ese identificador es por TIPO DE OBJETO:
    pod + MARIADB
    deployment + MARIADB
En ocasiones (SIEMPRE) querremos tener los objetos agrupados:
    Entorno produccion - namespace
        deployment MARIADB
    Entorno desarrollo - namespace
        deployment MARIADB
Los namespace permite segmentar un cluster en zonas independientes, con administración independiente
Para cada app/sistema que instalemos en cada entorno (desa, prod) tendremos un namespace

Namespaces importantes:
    kube-system: Alberga el plano de control de kubernetes
    default:     Namespace al que van las cosas si no digo nada. NO SE USA !!!!!
    kubernetes-dashboard

Cualquier comando* que hagamos con kubectl, deberá ir contra un namespace
    * salgo gloriosas excepciones que ya os contaré!
    
    
nextcloud-prod
nextcloud-pre
nextcloud-desa
mariadb-prod

Mover un POD: ESE CONCEPTO NO EXISTE
    Borro el pod 
    Crear donde quiera


POD:
    Contenedor:
        mariaDB

POD:
    initContainer:   // SCRIPTS QUE NECEITO PREVIO A EJECUTAR LO DE ABAJO
        waitMariaDB
        git clone
    Contenedor:      // DEMONIOS o SERVICIOS
        nextcloud
 
CRONJOB CRONTAB
    JOB_TEMPLATE: Un conjunto de contenedores que se ejecutan en serie(secuencialmente) y acaban
        BACKUP
        CRON
        
En el mundo de kubernetes  hay un par de herramentas estandarizadas que se usan para MONITORIZACION:
    Prometheus    / Grafana
    ElasticSearch / Kibana
    
    
Uso actual memoria es 100mb 
% ... con respecto a que?

Gibibyte
Mebibytes
Kibibyte

300Mi   Mebibytes
    1024
    
300Mb   Megabytes
    1000 


Giga, Mega Kilo SIEMPREKilometro =1000 metros
Kilobyte = 1000 bytes ¿?¿?¿?¿
kibibyte

30 Gb = 30 x 1000 Mb = 30 x 1000 x 1000 Kb
30 Gi = 30 x 1024 Mi = 30 x 1024 x 1024 Kb


500 milicores
    El equivalente a usar media CPU en un segundo

1000 milicores = 1 core al 100% durante 1 segmentar
                 2 cores al 50% en 1 segmentar
                 4 cores 25%
                 
Maquina 4 cpus
    pod nginx: 0,5 CPU
    pod nginx: 0,5 CPU
    pod nginx: 0,5 CPU
    pod nginx: 0,5 CPU
    
    
    
    
                 

CHARTS DE HELM

CHART plantilla (con cierta lógica) que se completan desde un fichero >>>>> values.yaml <<<<

$ helm template REPO/Plantilla -f values.yaml

antes de poder usar una plantilla (CHART) hemos de dar de alta el repo que la contiene


$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nginx

helm repo add bitnami https://charts.bitnami.com/bitnami
helm template bitnami/nginx > nginx.yaml             Me permite ver lo que voy a montar

helm pull --untar bitnami/nginx


helm install mi bitnami/nginx > nginx.yaml           Me permite instalar
    Servicio mi-nginx


helm repo add nextcloud https://charts.nextcloud.com/nextcloud



kubernetes solo mira si a nivel de SO existe un proceso nginx en funcionamiento


nextcloud -> apache 80
    maintenance => false          < config.php
    
    
BBDD
    MariaDB
            3306
    admin
    Arranado SI Me vale NO    Lo tengo que reiniciar
    Live? NO
    Ready? NO
    
    backup
    Arrancado SI Sirve a los clientes ? NO   Lo tengo que reiniciar? NO
    Live? SI
    Ready? NO



3 contenedores/pods de nextcloud
   1 minuto
   
servicio nextclud balanceo entre los pods Y/contenedores de nextcloud
    pod1
    pod2
    pod3

live? Sigue vivo no lo reinicio.
ready? no     No lo meto aun en backend del servoicio (balanceador)


nextcloud

lifenessprobe: 700 segundos http
    upgrade