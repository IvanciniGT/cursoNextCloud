#!/bin/bash

function metadata(){
    __RESOURCE=$1
    __API_VERSION=$2
    __NAME=$3
    echo "---"
    echo "kind: $__RESOURCE"
    echo "apiVersion: $__API_VERSION"
    echo 
    echo "metadata:"
    echo "    name: $__NAME"
    echo ""
    echo "data:"
    
}

