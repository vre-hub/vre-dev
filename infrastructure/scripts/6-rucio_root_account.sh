#!/bin/bash

# rucio namespace
RUCIO_NS="rucio-dev"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

echo "Create and apply rucio root account secret"

RAW_SECRETS="/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets/rucio-root-account.yaml"
OUTPUT_SECRET="rucio-root-account.yaml"
cat ${RAW_SECRETS} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_STORE}/ss_${OUTPUT_SECRET}

echo "Done"