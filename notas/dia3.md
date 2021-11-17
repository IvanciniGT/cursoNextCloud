Kubernetes : Operar un conjunto de dockers instalados a priori en un conjunto de maquinas independientes

docker -> dockerd
docker-compose -> dockerd

            demonio que tenemos en 1 maquina del cluster (maestra)
            VVVV                        demonio que tenemos en cada maquina del cluster
                                        VVV
kubectl -> kubernetes (apiserver) -> kubelet --> dockerd

Instalación de kubernetes:
    Instalar en cada maquina del cluster:
        kubelet                                             ** Se monta como un servicio a nivel del SO host
        kube-proxy          Controlar reglas de red 
    En la maestra, además: (PLANO DE CONTROL DE KUBERNETES)
        etcd                BBDD Interna de kubernetes
        scheduller          Determina en que máquina se van a montar unos determinados contenedores
        controller-manager  Monitorizando los contenedores
        coreDNS             Servidor DNS
        apiserver           Programa que recibe las peticiones del kubectl
        
    Todo el resto de programas se montan como contenedores

Kubernetes permite operar un cluster:
    Las apps dentro del cluster a priori no tengo ni idea de donde se instalarán

¿Qué pasaba cuando instalabamos docker?
    Los contenedores se pinchan a qué red? a la red lógica que crea docker... 
        esta red donde habita? dentro del host

En kubernetes nosotros vamos a tener contenedores repartidos entre varias maquinas,
    que queremos que hablen entre si
    
    MariaDB   -> Maquina 1   : Exponga el puerto 3306
    Nextcloud -> Maquina 2   : Exponga el puerto 80

¿Que problema supondría esta configuración? 
    Seguridad. Quien podría acceder al puerto del mariadb?
        Cualquiera que esté en la red publica... 
        Cualquiera que pudiera acceder tambien al puerto 80 del nextcloud: Quiero que todos
        
––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– Red publica de la empresa
                |                                       |
                Proxy reverso: Nginx                    Usuarios
                |
––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– Subred de la empresa
 |---------------------------| VLAN                     |
 ||                         ||                          Maquina n
 Maquina 1                  Maquina 2          
  |                         |   
  |-Pod Nextcloud           |- Pod MariaBD
        C Nextcloud                 C. MariaDB


Al instalar kubernetes :
    Paso 1: Prerequisitos:
        - Instala docker de una manera muy concreta
        - Desactivar SWAP a nivel del SO
    Paso 2: Instalar las herramienats de kubernetes: kubelet, kubectl, kubeadm (es la que permite crear un cluster)
    Paso 3: Crear un cluster: Se instala EL PLANO DE CONTROL DE KUBERNETES
    Paso 4: Crear una VLAN
    Paso 5: Disfrutar!
    
En Kubernetes la unidad mínima de trabajo no es el contenedor, sino el POD
Qué es un POD:
    Un conjunto de contenedores, que:
        - Se instalan en la misma máquina del cluster
        - Se instalan y operan conjuntamente
        - Comparten configuración de red (misma IP)
        - Pueden compartir volumenes
        - Se escalan conjuntamente

Pod0:
    Nginx -> ficheros de log: access.log (apache)   --> Volumen de datos (local o en red)
    Logstash: Contenedor-----------------------------------^
Pod1:
    Nextcloud - Un contenedor   
Pod2:
    MariaDB   - Otro contenedor 

Van en el mismo pack/POD? o van en pods separados? Separados

access.log? Los quiero mantener? Quizás si
            Los quiero mantener en la maquina donde está corriendo nginx? No... se me peta la máquina
            Quizás me interesa tenerlos en un entorno (programa) que posteriormente me permita su análisis:
                Logstash > ElasticSearch < Kibana



Maquina                         LAN (No tendría sentido) No aporta nada.... y satura la red
Nginx---------RED----------------^
   |
   V
   HDD
   Rotación entre 2 ficheros de Log
    Fichero 1 100kb   < Logstash   > ES (persistencia de los logs)    < Kibana
    Fichero 2 100kb   < --------
            --------
              200kb
              
              
Nginx (Maquina2)
^^^
Logstash


Nginx (Maquina3)
^^^
Logstash





------------------------------------------------------------------------------------------------


Maquina Virtual 1                                       Maquina Virtual 2           Almacenamiento en RED
- Kubernetes                                            - Kubernetes
- Maestra
    Tendrá el Plano de control de kubernetes
- Pods:                                                 - Pods:
                                                            MariaDB1               >    Volumen MariaDB 1
    MariaDB2                                                                       >    Volumen MariaDB 2
                                                            MariaDB3               >    Volumen MariaDB 3

Pods:
    Nextcloud. Cuantos?
        Si quiero HA: Con 1 vale (Activo-pasivo)        
        Si quiero Escalabilidad: Necesito n=17
    MariaDB: Cuantos?
        1: Si lo monto en modo standalone
            Esto da HA?
                Un poquito... solo un poquito. Por qué?
                    Si el programa se vuelve loco y se cae... que hace kubernetes?
                        Lo levanta de nuevo... esto entra dentro del apartado HA
                    Si el programa corrompe los ficheros de la BBDD... que hace kubernetes? kquita
                        Me tocaría hacer un restore de un backup que tuviera... más vale que lo tenga
        2: Si lo monto en modo replicación
            Esto da HA? Si, más y escalbilidad: Algo... tengo 2
        3: Cluster completo: MariaDB Galera: HA/Escalabilidad completa

Una cosa es dónde están ejecutandose los programas, y otra dónde están los datos de los programas?
En kubernetes, dado que los programas se pueden ejecutar a priori en cualquier nodo, sus datos
    no pueden estar ligados (almacenados) en ningun nodo
    Los datos deben estar en un volumen de red independiente
    
En kubernetes podemos establecer reglas de AFINIDAD a nivel de POD para das instrucciones al scheduller acerca
de donde instalar los pods

Nosotros en kubernetes no vamos a crear pods. NUNCA JAMAS !
    Lo puedo hacer? SI
    Lo voy a hacer: NUNCA JAMAS !
Qué haremos: Darle a kubernetes PLANTILLAS DE PODS.
    Kubernetes en base a esas plantilla irá creando PODS

Cliente que con su navegador quiere conectar con NEXTCLOUD. Puede?  A Priori no   
    mi-nextcloud.gc.es
    
DNS Publico                                         < NO LO GESTIONA KUBERNETES
    mi-nextcloud.gc.es = IP_NEXTCLOUD_PUBLICA
    
Balanceo de carga IP_NEXTCLOUD_PUBLICA:80           < SI LO GESTIONA KUBERNETES + MetalLB
    IPMaquina1:30000    
    IPMaquina2:30000  

Cluster de Kubernetes:
    Maquina 1
        - Linux
            netFilter
                IPS_MariaDB -> IP6:3306 | IP3:3306 | IP4:3306 | IP5:3306      < Esto también lo hace kubernetes
                IPS_NC      -> IP1:80      < Esto también lo hace kubernetes
                0.0.0.0:30000 -> nextcloud:80     < Esto también lo hace kubernetes
        Servidor Interno de Kubernetes de DNS
            mariadb = IPS_MariaDB (balanceo de carga)               < Esto lo hace kubernetes
            nextcloud = IPS_NC (balanceo de carga)                  < Esto lo hace kubernetes
        Pod Nextcloud        - IP1
                ---> MariaDB: mariadb
        Pod MariaDB 2         - IP3
        Pod MariaDB 3         - IP4
    Maquina 2
        - Linux
            netFilter
                IPS_MariaDB -> IP6:3306 | IP3:3306 | IP4:3306 | IP5:3306      < Esto también lo hace kubernetes
                IPS_NC      -> IP1:80      < Esto también lo hace kubernetes
                0.0.0.0:30000 -> nextcloud:80     < Esto también lo hace kubernetes
        Pod MariaDB 1         - IP2  PUFFFFF
        Pod MariaDB 4         - IP5
        Pod MariaDB 5         - IP6

Balanceo de carga: IPS_MariaDB:3333 ->   IP6:3306 | IP3:3306 | IP4:3306 | IP5:3306      < Esto también lo hace kubernetes

Service: Servicio
    ClusterIP  -> Un servicio es una entrada en el DNS de Kubernetes + IP de Balanceo
    NodePort   -> ClusterIP + Se abre un puerto (por encima del 30000) en CADA máquina del cluster
    LoadBalancer -> NodePort + gestión automatica de un balanceador externo al cluster (siempre que sea compatible)

Casi siempre asociado a un/varios pod(s) tendremos un OBJETO SERVICE ASOCIADO EN KUNERNETES
    

Que tipos de programas podemos ejecutar en un contendor de un pod:

Tipos de software?
    - Aplicación    Es un programa que corre en primer plano de forma 
                    indefinida en el tiempo y con interacción con usuarios personas físicas
                    EJ: Office, Navegador de Internet
    ** Servicio     Es un programa que corre en segundo plano de forma 
                    indefinida en el tiempo y con interacción no con usuarios personas físicas
                    sino con otros programas: Navegador de internet
                    Los servicios se ofrecen a través de puertos de comunicación... entre programas
    ** Demonio      Es un programa que corre en segundo plano de forma 
                    indefinida en el tiempo . Normalmente nos referimos a demonio y no lo llamamos servicio 
                    cuando este programa no interactua con nadie
    * Script        Es un programa que corre en primer o segundo plano...
                    de forma temporal (mientras acaba unas tareas) y que no tiene interacción con nadie
    --------------------
    - SO
    - Driver
    
    
    
                        Cliente
                            V
                        BALANCEADOR****
                            V
                    ---------------------------------
                    V                               V
    Maquina 1  : 30000                Maquina 2: 30000    > BALANCEO: Replica1, Replica2, Replica 3
        |                               |
        Pod A replica 1                 Pod A replica 3
        Pod A replica 2
        

Cuantos servicios tendremos en un cluster real de tipo:
    ClusterIP       (servicios internos)            TODOS menos 1
        Base de datos
        KeyCloud
        NextCloud
        Jitsy
    NodePort        (servicios externos)            0    Este solo lo usamos si no dispongo de un balanceado externo METALLB
                                                         En un entorno real, lo tengo... En un entorno de juguete me sirve para hacer pruebas
    LoadBalancer    (servicios externos****)        1
        Proxy reverso (nginx)                               <<<<<<< IngressController
            VirtualHosts -> Servicios internos
                nextcloud.gc.es -> servicio interno de nextcloud        <<<<<< Ingress
                jitsy.gc.es     -> servicio interno de jitsy

Objetos en Kubernetes:
    Pod
    Plantilla de pod
        Deployment:      Plantilla de pod, con un número de replicas,
            donde todas las replicas comparten volumen de almacenamiento
        StatefulSet:     Plantilla de pod, con un número de replicas, 
            donde cada replica tiene su propio volumen de al,acenamiento independiente
    Service
    Ingress

Nextcloud: 5 replicas. Van a compartir volumen de almacenamiento? SI -> DEPLOYMENT
    - Todas operansobre los mismos ficheros:
        configuración
        usuarios
        temas
        apps
MariaDB Galera: 3 replicas. Van a compartir volumen de almacenamiento? NO -> STATEFULSET

En cluster: Cada nodo guarda una parte de los datos
MariaDB Galera  
    Nodo 1
        datoA   datoB
    Nodo 2
        datoB   datoC
    Nodo 3
        datoA   datoC
ES
Kafka




PAUSA!
Instalar kubernetes: REAL !   K8S
    minikube

Montar un Servidor NFS: Almacenamiento externo al cluster

Montar un ejemplo sencillo de despliegue : NGINX

MÑN: NEXTCLOUD 

Cada uno tenemos un ordenador alquilado
    Montar un cluster con todos esos juntos
    
    
    
Ya tengo un cluster configurado y en funcionamiento (a falta de VLAN, me permitirá comunicar con otras maquinas)

kubectl CLIENTE DE KUBERNETES   Va a buscar el fichero de configuración en la ruta ~/.kube/config
    ^^^^
    Configuración de donde está el cluster (IP)
    Credenciales 
    
Donde lo necesito es allá desde donde quiera operar mi cluster




Maquina 1 - Cluster - Maestra
    ./kubernetes.sh
    ./master.sh
Maquina 2 - Cluster 
    ./kubernetes.sh


Maquina externa al cluster (Eso si, con posibilidad de conectar a li misma red)
    ./kubectl.sh   (ADMIN.conf del master -> CONFIG)
    kubectl < Permite controlar remotamente el cluster
    
Maquina 1 - Ivan - Maestra
Maquina 2
Maquina 3
Maquina 4
Maquina 5
    - Clientes
