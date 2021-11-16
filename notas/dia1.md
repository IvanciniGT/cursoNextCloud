# Contenedor

Entorno aislado donde ejecutar procesos dentro de un sistema operativo kernel Linux

Cuantos procesos puedo ejecutar en un contenedor? 
    Los que quiera. Al menos 1, el proceso asociado al contenedor.
    El primer proceso que abro al arrancar un contenedor queda vinculado al ciclo de vida del contenedor:
        - Si en un momento dado apago el proceso 1, el contenedor es cerrado (se detiene)
    
Entorno aislado:
    - Controla los recursos hardware a los que pueden acceder los procesos que corren en el contenedor
    * Su propio FileSystem: Sistema de archivos, independiente del FS del host
        Dentro de un contenedor podemos ejecutar los programas instalados (presentes) en el FS del contenedor
    * Su propia configuración de RED independiente de la del host
    - Sus propias variables de entorno

Cómo creamos (desde donde, qué) un contenedor?
    - Una imagen de contenedor.
    - Un programa que me permita gestionar contenedores (crearlos, arrancarlos, pararlos, descargar imagenes):
        * docker  <<< Lo hicieron muy bien... y tuvieros suerte (llegaron en el momento oportuno)
            - ESTANDARIZACION
        * containerd
        - crio
        - podman
        - warden
        - lxc
        - lmctfy

Cuando instalais office, que haceis lo primero?
    Me descargo una versión de office? Descargo un programa de instalación de office

En el mundo de los contenedores, lo que descargamos es una imagen de contenedor:
    Ahí dentro viene un programa YA INSTALADO

c:\archivos de programa\office -> ZIP

Qué es una imagen de contenedor?
- Un triste fichero ZIP con unas carpetas y archivos comprimidos dentro
- Configuración por defecto del entorno en el que se ejecutarán los procesos dentro del contenedor que se genere desde esta imagen
    - Unos valores por defecto para variables de entorno
    - Cuando arranquemos un contenedor generado desde esta imagen, que proceso es el que se va a arrancar por defecto
    - La carpeta por defecto en la que se trabaja en el contenedor
- Información adicional para quien vaya a usar esta imagen: (ESTO NO AFECTA A LA EJECUCION DE LOS PROCESOS)
    SOLO PARA QUE YO (PERSONA FISICA USANDO LA IMAGEN, ME ENTERE DE LO QUE HAY AHI)
    - Un listado de los puertos que abren los procesos que allí dentro se ejecuten (los que configuró el que hizo la imagen)
    - Un listado de las carpetas importantes donde se guarda información sensible ( que quiero perdurar)
    


Sistema operativo?
    Kernel:     LINUX
        Controla el hardware
        Ofrece un API (una serie de funciones) a otros programas para que puedan acceder a recursos del hardware
        Crea procesos
        controla esos procesos y su interacción con el hardware
        FileSystem
    Shell CLI:    Interfaz de usuario: sh, bsh-> bash, fish, zsh
    Shell GUI:    Interfaz de usuario gráfica -> GNOME, KDE
    Programas:
        Programas para controlar el FS:
            cd
            mkdir
            mv
            cp
            compiladores de lenguajes de programación    
        Juegos   chess
        Bloc de notas   gedit
        Editor de texto

UNIX®  Es la especifición de cómo montar un SO (SUS, POSIX)
    
SO UNIX. Cumplen con la especificación UNIX®
    HP:  HP-UX
    IBM: AIX
    Oracle: SOLARIS
    Apple: MacOS
    
SO tipo UNIX. Se supone que cumplen con la especificación UNIX®

386BSD  SO igual que UNIX. Litigio legal.
    BSD- FreeBSD ... netBSD

GNU/Linux
    Debian -> Ubuntu
    RedHat: RHEL, Fedora, CentOS, OracleLinux
    OpenSuse

SO más usado del mundo: Linux sin GNU: Android





Puedo correr contenedores en Windows? NO
                             MacOS?   NO



Mini sistema operativo
Como una maquina virtual pero que usa los recursos del host. No necesita un hipervisor
Dependencias mínimas de la app que quiero ejecutar.

Instalación de cualquier herramienta en un entorno de producción de cualquier empresa: CONTENEDORES
    Docker : Es una herramienta muy chula, muy reconoda, vinculada conceptualmente al nombre contenedor
             Pero que no usamos en los entornos de producción.
             Para pruebas, desarrollo, ejecución de programas puntual
    Kubernetes, Openshift:
        Me permiten controlar una granja de servidores donde tengo instalada una herramienta tipo docker
        Namespace - Entorno para un proyecto.
    
                                    Empresa (lo mas habitual a dia de hoy)
                                    Lo puedo hacer yo, sin problema (5 minutos)
La empresa me entrega un software ----------> Imagen de contenedor -----> YO, no la empresa, creo un contenedor (5)
Luego le puedo dar acceso a esos contenedores, para que hagan cosas alli dentro ¿?¿?¿?
    En una actualización, obtendré una nueva imagen.
        Los contenedores antiguos, los liquido, borro, elimino, destrozo
        Creo nuevos contenedores
        
Está estandarizado.
     Me da igual que me pidan instalar un oracle, nginx, app personalizada hecha en casa...
     Todo se instala igual          |
     Todo se opera igual            | Me es facil automatizarlo script.sh (YO,y además diferente para cada app)
     Todo se mantiene igual         |
     
     
FileSystem de un contenedor
    - Está montado mediante la superposición de capas
    
HOST LINUX: Sistema de archivos (FS)
ROOT: /
        bin/
            cp
        sbin/
        var/
            lib/
                docker/
                    containers/
                        ID DE UN CONTENEDOR: 192874398364819763972649273648716348716328794786/
                            tmp/
                                nginx/
                                    archivo1.log
                    images/
                        nginx/   <<<<<< Se entienda como el ROOT del FS del contenedor: chroot
                            bin/
                                mkdir - necesidades del nginx
                                rm    - necesidades del nginx
                                touch - necesidades del nginx
                                curl  - necesidades del nginx
                                cp
                                bash  - No lo necesita nginx... pero a lo mejor a mi (PERSONA FISICA) me interesa
                            etc/
                                nginx/
                                    archivos de configuración de nginx
                            var/
                                nginx/
                                    webs que quiero publicar
                            opt/
                                nginx/
                                    programa nginx
                            tmp/
                                nginx/
                                    archivos temporales que se generen
                            var/
                                nginx/
                                    logs de nginx
        opt/
        etc/
        tmp/
        home/
        root/
        datos/
            var/
                nginx/
                    archivo17.txt
        
Imagen de contenedor para ejecutar nginx
ZIP: Instalación de nginx + otras cosas:
    - Cosas que necesite nginx para operar
    - Otras utilidades que me puedan interesar en un momento dado

/
    bin/
        mkdir - necesidades del nginx
        rm    - necesidades del nginx
        touch - necesidades del nginx
        curl  - necesidades del nginx
        bash  - No lo necesita nginx... pero a lo mejor a mi (PERSONA FISICA) me interesa
    etc/
        nginx/
            archivos de configuración de nginx
    var/
        nginx/
            webs que quiero publicar
    opt/
        nginx/
            programa nginx
    tmp/
        nginx/
            archivos temporales que se generen
    var/
        nginx/
            logs de nginx
            
            
            
Cuando un proceso ejecutandose en un contenedor basado en la imagen de nginx quiera acceder a un path:
    /var/nginx/archivo1.log.... Realmente el root / no va a ser el root del FS del host,
                                sino que va a a ser /var/lib/docker/images/nginx/
                                
                                /var/lib/docker/images/nginx/var/nginx/archivo1.log
                                                            /var/nginx/archivo1.log


FILESYSTEM de un CONTENEDOR: CAPAS

    VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VOLUMENES:
    CAPA 2: ---> Tendra su persistencia  donde yo defina < HOST, NFS, CLOUD, ISCSI, CABINA FIBRE CHANNEL
        Su persistencia es a nivel del host en /datos
        
                                                     /var
                                                        /nginx
                                                            archivo17.txt

CAPA 1: Capa a nivel de contenedor (recoje TODOS los cambios que se hagan en el FS del contenedor)
                                             /tmp/
                                                nginx/
                                                    archivo1.log
                                                    
CAPA 0: Capa de la imagen del contenedor (INALTERABLE)
    /bin       /etc                  /opt    /tmp    /var
      /cp        nginx/
                     nginx.conf


Desde el contenedor:
1- Yo soy un proceso que se ejecuta en el contenedor y quiero ejecutar el comando /bin/cp
2- Quiero crear un archivo en /tmp/nginx/archivo1.log
    La capa 0, la de la imagen es INALTERABLE

Qué problema tiene la capa 1? A nivel del host se guarda en una capreta cuyo nombre es el ID del contenedor
Qué pasa si un día borro el contenedor? 
    Esa caperta (la de capa 1) a nivel del host es eliminada
    Por tanto, todos los cambios que haya realizado en el FS se borran
    Pero la persistencia real de los volumenes adicionales (CAPA 2 en adelante) no se toca:
        /datos/var/nginx/fichero17.txt (a nivel de host)
        
Cuando trabajo con contenedores nada más, sin ningún YAML ni nada.

Un YAML (docker-compose, kubernetes)... eso solo me permite especificar más cómoda los detalles de 
    un contenedor que quiero generar

Si trabajo con docker  a pelo (directamente) y borro un contenedor y lo creo de nuevo, a todos los efectos
son 2 contenedores DIFERENTES... o les monto los mismos volumenes ... o no tengo na que hacer



DOCKER es una empresa
-------------------------------------
Docker engine <<<< lo que comunmente conocemos como docker
    demonio - dockerd
                containerd <<<< Este es el programa que realmente gestiona los contenedores
                    runc <<< Quien ejecuta un contenedor
    cliente - docker
    
    


Cuantas interfaces de red tiene una maquina normalmente...
Al menos siempre 1:
    loopback - [localhost] = 127.0.0.1      ---> NIC (NO... es una red lógica)
        ? Para poder comunicar procesos que se ejecuten dentro del host
    eth0                   = 172.31.3.162   ---> NIC (Tarjeta de red)
    docker0                = 172.17.0.1          bridge (es una red lógica)
    
    
    
mi-nginx = 172.17.0.2




------------------------------------------------------------------ Red de amazon
| IP: 172.31.3.162      |                    | IP: 172.31.2.189
host:                   |                    host 2
    |                   |                             -> 172.31.3.200:80
    | IP: 172.17.0.1    |
    |                   |
    |                   |
    |- C mi-nginx: 172.31.3.200:80
    |
    |
    | red docker0
    
                                                            iptables (reglas de red)
                                                              VVV
Dentro del kernel de Linux existe un programa que se llama NETFILTER:
    Este programa gestiona todas los paquetes de red que circulan por cualquier 
    interfaz de red del host donde está el SO
    
    
Al CREAR un contenedor, podré:
    Decirle a quered le pincho
    Limitar el acceso a recursos de HW
    Montar volumenes
    Redirecciones de puertos
    Definir variables de entorno

A posterior cualuier cambio va a implicar: 
    El borrador del contenedor actualizaciY levantar (crear) un contenedor
        TOTALMENTE NUEVO con la nueva configuración
        
# Montar un contenedor con MariaDB

docker run:
    docker image pull
    docker container create --
    docker container start  --
    docker container attach 
    -d detached
    
    
Docker run está guay para lanzamientos one-shot
docker run --rm ubuntu -v miscript:/scripts 

docker container create \
    --name mi-mariadb-2 \
    -e MARIADB_ROOT_PASSWORD=password \
    -e MARIADB_DATABASE=curso \
    -e MARIADB_USER=usuario \
    -e MARIADB_PASSWORD=password \
    -v /home/ubuntu/environment/datos/mariadb:/var/lib/mysql\
    --network bridge \
    -p 0.0.0.0:3307:3306 \
    mariadb:latest
    
# Cuando trabajo con el driver bridge, me interesa un mapeo de puertos, para que maquinas conectadas a mi misma red 
#  publica puedan acceder al puerto del contenedor a través mio (del host)