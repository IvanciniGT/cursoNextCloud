#!/bin/bash

source $(dirname $BASH_SOURCE)/common.sh

function generateFile(){
    metadata $__RESOURCE $__API_VERSION $__NAME> $__FILENAME

    echo  "${!__SECRETOS[@]}"

    for clave in "${!__SECRETOS[@]}"
    do
        echo "  $clave: $(echo ${__SECRETOS["$clave"]} | base64)" >> $__FILENAME
    done
}


__RESOURCE=Secret
__API_VERSION=v1
__FILENAME=$(mktemp /tmp/$__RESOURCE.XXX)
declare -A __SECRETOS 


while [[ $# > 0 ]]
do
    case "$1" in
        --namespace|-p|--namespace=*|-p=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __NAMESPACE=$1
            else
                __NAMESPACE=${1#*=}
            fi 
        ;;
        --name|-n|--name=*|-n=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __NAME=$1
            else
                __NAME=${1#*=}
            fi 
        ;;
        --secret|-s)
            shift
            if [[ "$1" != *=* ]]; then 
                echo "Uso incorrecto de la funcion createSecret. Secreto incorrecto: $1. Falta el valor" >&2
                exit 1
            fi 
            __CLAVE=${1%=*}
            __VALOR=${1#*=}
            __SECRETOS[$__CLAVE]=$__VALOR
        ;;

        *) # valor no procesado hasta ahora
            echo "Uso incorrecto de la funcion createSecret. Argumento inválido: $1" >&2
            exit 1
        ;;
    esac
    shift
done

generateFile
cat $__FILENAME

kubectl apply -f $__FILENAME -n $__NAMESPACE