#!/bin/bash

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_SERVERS="/root/clusters_CERTS/dev-cern-vre/servers-dev"
RAW_SECRETS_SERVERS_AUTH="/root/clusters_CERTS/dev-cern-vre/servers-auth-dev"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# helm release names
HELM_RELEASE_SERVER="servers-dev"
HELM_RELEASE_SERVER_AUTH="servers-auth-dev"
# HELM_RELEASE_UI="webui-vre"
# HELM_RELEASE_DAEMONS="daemons-vre"

# rucio namespace
RUCIO_NS="rucio-dev"

# sealed secret output yaml prefix
#YAML_PRFX="ss_"

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

echo "Create and apply SERVER secrets"

kubectl create secret generic ${HELM_RELEASE_SERVER}-server-hostcert --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER}-server-hostkey --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-hostkey.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-hostkey.yaml

# The content of this file is the same as in /etc/pki/tls/certs/ca.pem but renamed.
kubectl create secret generic ${HELM_RELEASE_SERVER}-server-cafile --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-cafile.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-cafile.yaml


echo "Create and apply SERVER AUTH secrets"

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-server-hostcert --dry-run=client --from-file=${RAW_SECRETS_SERVERS_AUTH}/hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-server-hostkey --dry-run=client --from-file=${RAW_SECRETS_SERVERS_AUTH}/hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostkey.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostkey.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-server-cafile --dry-run=client --from-file=${RAW_SECRETS_SERVERS_AUTH}/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-server-cafile.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-server-cafile.yaml

# Create server secret for the GridCA file
# The content of this file is the same as in /etc/pki/tls/certs/CERN-GridCA.pem but mv'd.
kubectl create secret generic ${HELM_RELEASE_SERVER}-server-gridca --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/CERN-GridCA.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-gridca.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-server-gridca.yaml