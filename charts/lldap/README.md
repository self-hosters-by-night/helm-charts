# LLDAP

[LLDAP](https://github.com/lldap/lldap) is a lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication. It integrates with many backends, from Keycloak to Authelia to Nextcloud and more!

## Requirements

- Kubernetes version >= 1.19

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install lldap self-hosters-by-night/lldap
```

## Upgrading

A major chart version change can indicate that there is an incompatible breaking change needing manual actions.

_No recent breaking changes needing manual actions._
