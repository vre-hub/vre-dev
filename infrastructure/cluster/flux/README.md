# Flux

Flux was installed manually via: 
```
flux bootstrap github --owner=vre-hub --repository=vre-dev --branch=main --path=infrastructure/cluster/flux --author-name flux-ops
``` 
with version v2.1.1. 

Manifests inside the path `infrastructure/cluster/flux` will be automatically deployed to the VRE-dev cluster.

Refer to the [official flux docs](https://fluxcd.io/flux/) for information on how to add manifests e. g. helm charts and add kustomizations.


## How to add and synchronise a helm chart via flux

Because flux is going to keep everything sync, you have to used the flux "syntax" to add Helm charts.

How to do :
 1. Create manually the desired namespace: `kubectl create namespace <NAMESPACE>`
 2. Add the following flux files:
     - The flux `namespace` file with the namespace you just created.
     - The flux `HelmReposity` pointing to the URL of the Helm chart.