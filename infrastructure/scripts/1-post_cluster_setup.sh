#!/bin/bash

# post setup cluster configuration --> alternatively also use tf with k8s provider to label resources and get nodes through kubernetes_resource data

# get cluster config for kubectl
# $(openstack coe cluster config $cluster)
# export KUBECONFIG="config"

# extract node prefix
NODE_PREFIX=$(kubectl get nodes -l magnum.openstack.org/role=worker --sort-by .metadata.name -o name | head -n 1)
NODE_PREFIX=${NODE_PREFIX%-0}
echo $NODE_PREFIX

# TO USE NGINX INGRESS CONTROL
# set ingress nodes for the first three infrasteucture nodes
FIRST_3NODES=$(kubectl get nodes -l magnum.openstack.org/role=worker --sort-by .metadata.name -o name | head -n 3)
for NODE in $FIRST_3NODES
do
    kubectl label "$NODE" role=ingress
done


