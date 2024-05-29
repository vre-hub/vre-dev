# CVMFS 
## CVMFS on the VRE-DEV

CERN OpenStack k8s cluster v1.29 is deployed with a `cvmfs StorageClass` provisioned by `cvmfs.csi.cern.ch` and the CVMFS CSI (Container Storage Interface) plugin [link to github repository](https://github.com/cvmfs-contrib/cvmfs-csi). 

Deployed versions are `cvmfs-csi:v2.3.1` and `csi-node-driver-registrar:v2.6.2`.

To provision a cvmfs volume within any jupyterhub pod:
* Create a `pvc` making use of the cvms `StorageClass`
* Add an `extraVolumes` and an `extraVolumeMounts` in the [JupyterHub release manifest](../jhub-dev/jhub-dev-release.yaml).

The manifests within this directory will also deploy a pod (`cvmfs-client`) to access cvmfs from the cluster.