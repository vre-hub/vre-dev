#!/bin/bash

SECRET_TMP_DIR="/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets"
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/jhub-dev"
NAMESPACE="jhub-dev"

SECRET_FILE=${SECRET_TMP_DIR}/jhub-vre-dev-iam-secrets.yaml
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_jhub-dev-iam-secrets.yaml
kubectl apply -f ${SECRETS_STORE}/ss_jhub-dev-iam-secrets.yaml

SECRET_FILE=${SECRET_TMP_DIR}/jhub-dev-db.yaml
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_jhub-dev-db.yaml
kubectl apply -f ${SECRETS_STORE}/ss_jhub-dev-db.yaml


#kubectl create secret tls cern-sectigo-tls-certificate --key="tls.key" --cert="tls.crt" --dry-run=client -o yaml | \
#kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=shared-services --format yaml --namespace=${NAMESPACE} > ss_cern-sectigo-tls-certificate.yaml

# To create a persistant auth-state for the jhub configuration
SECRET_FILE="jhub-dev-auth-state.yaml"
SECRET_FULL_PATH=${SECRET_TMP_DIR}/${SECRET_FILE}
echo "Creating ${SECRET_FILE} secret"
cat $SECRET_FULL_PATH | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_FILE}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_FILE}

## OAUTH Zenodo credentials
SECRET_FILE="jhub-dev-zenodo-oauth-credentials.yaml"
SECRET_FULL_PATH=${SECRET_TMP_DIR}/${SECRET_FILE}
echo "Creating ${SECRET_FILE} secret"
cat $SECRET_FULL_PATH | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_FILE}
kubectl apply -f ${SECRETS_STORE}/ss_jhub-dev-db.yaml