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