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

How to do so:
 1. Create manually the desired namespace: `kubectl create namespace <NAMESPACE>`
 2. Add the following flux files:
     - The flux `namespace` file with the namespace you just created.
     - The flux `HelmReposity` pointing to the URL of the Helm chart.
     - Following "our" (the cern-vre) logic, name these two files: `<APP>-namespace.yaml` and `<APP>-helm_repository.yaml` (or `<APP>-chart,yaml`), respectively. 
 3. After checking that the `helmRepository` has been correctly sync to the cluster, you can finally add the chart (`<APP>-release.yaml`) file. 
    - The relase manifest will set the chart, version and interval time to be sync,
    - from this file you would also be able to pass all the `values` to the installation.