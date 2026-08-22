# Valkey

[Valkey](https://valkey.io) is a high-performance key/value datastore, a Redis-compatible fork supporting workloads like caching and message queues.

This is meant to be a basic deployment of a single Valkey instance for small projects or services that need a lightweight RESP server.

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install valkey self-hosters-by-night/valkey
```

## Notes

- Data is persisted to a `data` volume claim template mounted at `/data` (RDB/AOF files); disable `persistence` for cache-only usage.
- `auth.enabled` configures `requirepass`; the password is read from `auth.existingSecret` or stored in a chart-managed Secret.
- The default health probes use `valkey-cli ping` and pick up the password automatically via the injected `VALKEY_PASSWORD` variable.
- `env.vars` values and ConfigMap/Secret references in `env.fromConfigMap`, `env.fromSecret`, and `envFrom` accept Helm templating (e.g., `{{ .Release.Name }}-valkey`).
