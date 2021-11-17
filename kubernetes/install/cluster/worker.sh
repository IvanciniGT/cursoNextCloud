#!/bin/bash


# Esto se ejecuta en un maestro
kubeadm token create --print-join-command

# El resultado se ejecuta en los workers

echo kubectl label nodes worker1 etiqueta=valor