#!/bin/bash

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_DAEMONS="/root/clusters_CERTS/cern-vre-dev/daemons-dev"
RAW_SECRETS_BUNDLE="/root/clusters_CERTS/cern-vre-dev/daemons-dev/ca-bundle_files/"
RAW_SECRETS_FTS="/root/clusters_CERTS/cern-vre-dev/daemons-dev/fts-robot-cert"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" # This can be checked in k8s/Services

# helm release names
HELM_RELEASE_DAEMONS="daemons-dev"

# rucio namespace
RUCIO_NS="rucio-dev"

# sealed secret output yaml prefix
#YAML_PRFX="ss_"

# Output dir
SECRETS_STORE="/root/software/vre-dev/infrastructure/secrets/rucio-dev"

# The content of this file is the same as in /etc/pki/tls/certs/ca.pem but renamed.
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-cafile --dry-run=client --from-file=${RAW_SECRETS_DAEMONS}/cafile.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-cafile.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-cafile.yaml

# rm -rf ${RAW_SECRETS_BUNDLE}
mkdir -p ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.0 ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.signing_policy ${RAW_SECRETS_BUNDLE}

# # kubeseal has problems with secretsthis large, so it needs to be created manually and not applied with kubeseal
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle --from-file=${RAW_SECRETS_BUNDLE} --namespace=${RUCIO_NS}
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle-reaper --from-file=${RAW_SECRETS_BUNDLE} --namespace=${RUCIO_NS} # kubeseal has problems with secretsthis large, so it needs to be created manually

# FTS secrets from ewp2c01 Robot certificate

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-cert --dry-run=client --from-file=${RAW_SECRETS_FTS}/ewp2c01-cert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-key --dry-run=client --from-file=${RAW_SECRETS_FTS}/ewp2c01-key.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-fts-key.yaml

kubectl apply -f ${SECRETS_STORE}/ss_${HELM_RELEASE_DAEMONS}-fts-key.yaml
