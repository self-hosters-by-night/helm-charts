# Fission CRDs

This chart contains only the CRDs for Fission.

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install fission-crds self-hosters-by-night/fission-crds
```

## Updating

The chart can be updated with the following command:

```shell
VERSION=v1.20.5
kustomize build "github.com/fission/fission/crds/v1?ref=${VERSION}" -o crds
```
