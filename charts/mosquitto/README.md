# Popeye

[Popeye](https://popeyecli.io) is a utility that scans live Kubernetes clusters and reports potential issues with deployed resources and configurations.

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install popeye self-hosters-by-night/popeye
```
