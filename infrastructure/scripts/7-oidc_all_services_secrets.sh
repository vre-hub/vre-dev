#!/bin/bash

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# helm release names
# HELM_RELEASE_SERVER="servers-dev"
HELM_RELEASE_SERVER_AUTH="servers-auth-dev"
HELM_RELEASE_UI="webui-dev"
HELM_RELEASE_DAEMONS="daemons-dev"

# rucio namespace
RUCIO_NS="rucio-dev"

# sealed secret output yaml prefix
#YAML_PRFX="ss_"

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

RAW_SECRETS_IDP="/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets/idpsecrets.json"

# WATCH OUT that the secret needs to be called ${HELM_RELEASE_SERVER}-idpsecrets, but the reference in the .yaml file is only:
 
 # values:
 #   secretMounts:
 #       secretName: idpsecrets
 #       mountPath: /opt/rucio/etc/idpsecrets.json
 #       subPath: idpsecrets.json

echo "Creating and applying oidc secrets for server-auth ui and daemons"

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP} -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER_AUTH}-idpsecrets.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP} -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-idpsecrets.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP} -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

echo "Done"