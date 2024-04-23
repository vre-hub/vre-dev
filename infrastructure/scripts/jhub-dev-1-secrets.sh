kubectl create secret generic jhub-dev-iam-secrets --dry-run=client --from-file=/root/software/vre-dev/infrastructure/secrets/tmp_local_secrets/jhub-vre-dev-iam-secrets.yaml -o yaml | \
kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=jhub-dev > /root/software/vre-dev/infrastructure/secrets/jhub-dev/ss_jhub-dev-iam-secrets.yaml

#kubectl create secret tls cern-sectigo-tls-certificate --key="tls.key" --cert="tls.crt" --dry-run=client -o yaml | \
#kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=shared-services --format yaml --namespace=jhub > ss_cern-sectigo-tls-certificate.yaml
