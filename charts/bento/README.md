# Bento

[Bento](https://warpstreamlabs.github.io/bento/docs/about) is a declarative data streaming service that solves a wide range of data engineering problems with simple, chained, stateless processing steps. It implements transaction based resiliency with back pressure, so when connecting to at-least-once sources and sinks it's able to guarantee at-least-once delivery without needing to persist messages during transit.

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install bento self-hosters-by-night/bento
```
