# Postgres

[Postgres](https://www.postgresql.org) is an object-relational database system that provides reliability and data integrity.

This is meant to be a basic deployment of a single Postgres instance for small projects or services that do not require an entire Postgres cluster.

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install postgres self-hosters-by-night/postgres
```
