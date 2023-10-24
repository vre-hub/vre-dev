#!/bin/bash

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# rucio namespace
RUCIO_NS="rucio-dev"

# sealed secret output yaml prefix
#YAML_PRFX="ss_"

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

yaml_file_secret="/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets/rucio-dev-db.yaml"

# name of output secret to apply
OUTPUT_SECRET="rucio-dev-db.yaml"
cat ${yaml_file_secret} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_STORE}/ss_${OUTPUT_SECRET}
