#!/bin/bash

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_UI="/root/clusters_CERTS/cern-vre-dev/webui-dev"

# helm release names
HELM_RELEASE_UI="webui-dev"

# rucio namespace
RUCIO_NS="rucio-dev"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

echo "Create and apply ui secrets"

kubectl create secret generic ${HELM_RELEASE_UI}-hostcert --dry-run=client --from-file=${RAW_SECRETS_UI}/hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-hostkey --dry-run=client --from-file=${RAW_SECRETS_UI}/hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-hostkey.yaml

kubectl apply -f  ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-hostkey.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-cafile --dry-run=client --from-file=${RAW_SECRETS_UI}/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-cafile.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_UI}-cafile.yaml

echo "Done"