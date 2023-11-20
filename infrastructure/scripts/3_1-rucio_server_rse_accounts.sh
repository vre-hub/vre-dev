#!/bin/bash

# rucio namespace
RUCIO_NS="rucio-dev"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# helm release names
HELM_RELEASE_SERVER="servers-dev"

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

RAW_SECRETS="/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets/rse-accounts.cfg"

echo "Create RSE secret for server to recognise S3 storage"

kubectl create secret generic ${HELM_RELEASE_SERVER}-rse-accounts --dry-run=client --from-file=${RAW_SECRETS} -o yaml \
| kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-rse-accounts.yaml
kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_SERVER}-rse-accounts.yaml

echo "Done"
