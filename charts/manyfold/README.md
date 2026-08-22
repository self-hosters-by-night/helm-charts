# Manyfold

[Manyfold](https://manyfold.app) is a self-hosted digital asset manager for 3d print files.

## Install

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
helm install manyfold self-hosters-by-night/manyfold
```

## Notes

- The default image (`manyfold3d/manyfold-solo`) bundles Redis inside the container; SQLite is stored under `/config`.
- Set `image.repository=ghcr.io/manyfold3d/manyfold` for the standard image (Rails + Sidekiq workers via s6). It requires an external Redis/Valkey — enable the bundled one with `valkey.enabled=true`, which configures `REDIS_URL` automatically.
- Enable PostgreSQL with `postgres.enabled=true` (configures `DATABASE_*` automatically); otherwise Manyfold uses SQLite on the `/config` claim.
- By default `SECRET_KEY_BASE` is provisioned through the External Secrets Operator from OpenBao (key `shbn/manyfold`); set `env.fromSecret: null` and provide your own via `env.vars` when not using ESO.
