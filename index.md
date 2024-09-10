# Self-Hosters by Night

## Helm Repository

### Add the Repository

```shell
helm repo add self-hosters-by-night https://self-hosters-by-night.github.io/helm-charts
helm repo update self-hosters-by-night
```

### Search the Repository

```shell
helm search repo self-hosters-by-night
```

### Install a Helm Chart

> Please replace <release_name>, <namespace> and <chart_name> with values that match your environment.

#### Using the default configuration

```shell
helm install <release_name> -n <namespace> self-hosters-by-night/<chart_name>
```

#### Using your own configuration file

```shell
helm install <release_name> -n <namespace> -f values.yaml self-hosters-by-night/<chart_name>
```

#### Setting values from command-line

```shell
helm install <release_name> -n <namespace> --set <key>=<value> self-hosters-by-night/<chart_name>
```

### Issues

If you experience any issues using these Helm Charts please raise an issue [here](https://github.com/self-hosters-by-night/helm-charts/issues).
