#!/bin/bash

SECRET_TMP_DIR="/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets"

SECRET_FILE=${SECRET_TMP_DIR}/jhub-vre-dev-iam-secrets.yaml
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=jhub-dev > /root/software/vre-dev/infrastructure/secrets/jhub-dev/ss_jhub-dev-iam-secrets.yaml
kubectl apply -f /root/software/vre-dev/infrastructure/secrets/jhub-dev/ss_jhub-dev-iam-secrets.yaml

SECRET_FILE=${SECRET_TMP_DIR}/jhub-dev-db.yaml
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=jhub-dev > /root/software/vre-dev/infrastructure/secrets/jhub-dev/ss_jhub-dev-db.yaml
kubectl apply -f /root/software/vre-dev/infrastructure/secrets/jhub-dev/ss_jhub-dev-db.yaml


#kubectl create secret tls cern-sectigo-tls-certificate --key="tls.key" --cert="tls.crt" --dry-run=client -o yaml | \
#kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=shared-services --format yaml --namespace=jhub > ss_cern-sectigo-tls-certificate.yaml
