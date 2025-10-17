# Graphite Helm Chart

A highly scalable real-time graphing system for monitoring and storing numeric time-series data.

## Quick Start

### Prerequisites

- Kubernetes 1.24+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

### Installation

Add the CloudPirates repository:

To install the chart with the release name `my-graphite`:

```bash
helm install my-graphite oci://registry-1.docker.io/cloudpirates/graphite
```

To install with custom values:

```bash
helm install my-graphite oci://registry-1.docker.io/cloudpirates/graphite -f my-values.yaml
```

Or install directly from the local chart:

```bash
helm install my-graphite ./charts/graphite
```

### Getting Started

1. Access the Graphite web interface:

```bash
kubectl port-forward svc/my-graphite 8080:8080
```

Then open http://localhost:8080 in your browser.

2. Send metrics to Graphite:

```bash
# Via Carbon (plaintext protocol)
echo "test.metric 42 $(date +%s)" | nc my-graphite 2003

# Via StatsD (if enabled)
echo "test.counter:1|c" | nc -u my-graphite 8125
```

## Configuration

### Image Configuration

| Parameter                 | Description                           | Default                        |
| ------------------------- | ------------------------------------- | ------------------------------ |
| `image.registry`          | Graphite image registry               | `docker.io`                    |
| `image.repository`        | Graphite image repository             | `graphiteapp/graphite-statsd`  |
| `image.tag`               | Graphite image tag                    | `1.1.10-5`                     |
| `image.pullPolicy`        | Image pull policy                     | `IfNotPresent`                 |
| `global.imageRegistry`    | Global Docker image registry override | `""`                           |
| `global.imagePullSecrets` | Global Docker registry secret names   | `[]`                           |

### Common Parameters

| Parameter           | Description                                     | Default |
| ------------------- | ----------------------------------------------- | ------- |
| `nameOverride`      | String to partially override graphite.fullname | `""`    |
| `fullnameOverride`  | String to fully override graphite.fullname     | `""`    |
| `namespaceOverride` | String to override the namespace for all resources | `""` |
| `commonLabels`      | Labels to add to all deployed objects          | `{}`    |
| `commonAnnotations` | Annotations to add to all deployed objects     | `{}`    |
| `replicaCount`      | Number of Graphite instances to deploy         | `1`     |

### Pod Configuration

| Parameter        | Description                           | Default |
| ---------------- | ------------------------------------- | ------- |
| `podLabels`      | Map of labels to add to the pods      | `{}`    |
| `podAnnotations` | Map of annotations to add to the pods | `{}`    |

### Port Configuration

| Parameter                   | Description                      | Default |
| --------------------------- | -------------------------------- | ------- |
| `ports.webapp`              | Graphite web application port    | `8080`  |
| `ports.carbon`              | Carbon receiver port (plaintext) | `2003` |
| `ports.carbonPickle`        | Carbon receiver port (pickle)    | `2004`  |
| `ports.carbonAggregator`    | Carbon aggregator port           | `2023`  |
| `ports.statsd`              | StatsD port                      | `8125`  |

### Security Context

| Parameter                              | Description                     | Default |
| -------------------------------------- | ------------------------------- | ------- |
| `podSecurityContext.fsGroup`           | Pod security context fsGroup    | `998`   |
| `containerSecurityContext.runAsUser`   | Container user ID               | `998`   |
| `containerSecurityContext.runAsGroup`  | Container group ID              | `998`   |
| `containerSecurityContext.runAsNonRoot`| Run as non-root user            | `true`  |

### Resource Management

| Parameter                    | Description                         | Default |
| ---------------------------- | ----------------------------------- | ------- |
| `resources.limits.cpu`       | CPU limit for Graphite container    | `1000m` |
| `resources.limits.memory`    | Memory limit for Graphite container | `2Gi`   |
| `resources.requests.cpu`     | CPU request for Graphite container  | `100m`  |
| `resources.requests.memory`  | Memory request for Graphite container | `512Mi` |

### Persistence

| Parameter                      | Description                                | Default           |
| ------------------------------ | ------------------------------------------ | ----------------- |
| `persistence.enabled`          | Enable persistence for Graphite data      | `true`            |
| `persistence.storageClass`     | StorageClass for persistent volume        | `""`              |
| `persistence.accessModes`      | Access modes for persistent volume        | `["ReadWriteOnce"]` |
| `persistence.size`             | Size of persistent volume                  | `10Gi`            |
| `persistence.annotations`      | Annotations for persistent volume claim    | `{}`              |

### Service Configuration

| Parameter                         | Description                        | Default     |
| --------------------------------- | ---------------------------------- | ----------- |
| `service.type`                    | Service type                       | `ClusterIP` |
| `service.clusterIP`               | Static cluster IP address          | `""`        |
| `service.sessionAffinity`         | Session affinity for service       | `None`      |
| `service.sessionAffinityConfig`   | Session affinity configuration     | `{}`        |
| `service.annotations`             | Service annotations                | `{}`        |
| `service.labels`                  | Service labels                     | `{}`        |

### Ingress Configuration

| Parameter                | Description                              | Default |
| ------------------------ | ---------------------------------------- | ------- |
| `ingress.enabled`        | Enable ingress for Graphite web interface | `false` |
| `ingress.className`      | Ingress class name                       | `""`    |
| `ingress.annotations`    | Ingress annotations                      | `{}`    |
| `ingress.hosts`          | Ingress hosts configuration             | See values.yaml |
| `ingress.tls`            | Ingress TLS configuration               | `[]`    |

### ServiceMonitor Configuration

| Parameter                     | Description                                    | Default |
| ----------------------------- | ---------------------------------------------- | ------- |
| `serviceMonitor.enabled`      | Enable ServiceMonitor for Prometheus monitoring | `false` |
| `serviceMonitor.namespace`    | Namespace for ServiceMonitor                   | `""`    |
| `serviceMonitor.interval`     | Scrape interval                                | `30s`   |
| `serviceMonitor.scrapeTimeout`| Scrape timeout                                 | `10s`   |
| `serviceMonitor.labels`       | ServiceMonitor labels                          | `{}`    |
| `serviceMonitor.annotations`  | ServiceMonitor annotations                     | `{}`    |

### Graphite Configuration

| Parameter                           | Description                          | Default |
| ----------------------------------- | ------------------------------------ | ------- |
| `config.carbonCacheSize`            | Carbon cache size                    | `100000` |
| `config.maxCreatesPerMinute`        | Maximum creates per minute           | `50`    |
| `config.maxUpdatesPerSecond`        | Maximum updates per second           | `500`   |
| `config.timezone`                   | Timezone for Graphite               | `UTC`   |
| `config.logLevel`                   | Log level for Graphite services      | `INFO`  |
| `config.enableLogRotation`          | Enable log rotation                  | `true`  |
| `config.whisperAutoflush`           | Whisper autoflush setting            | `false` |

### Storage Configuration

| Parameter                               | Description                        | Default |
| --------------------------------------- | ---------------------------------- | ------- |
| `config.storage.patterns[].name`       | Storage pattern name               | `default` |
| `config.storage.patterns[].pattern`    | Metric pattern to match            | `*`     |
| `config.storage.patterns[].retentions` | Retention policy                   | `60s:1d,300s:7d,3600s:1y` |

### Carbon Configuration

| Parameter                                | Description                        | Default   |
| ---------------------------------------- | ---------------------------------- | --------- |
| `config.carbon.enableUdp`               | Enable UDP listener for Carbon     | `false`   |
| `config.carbon.lineReceiverInterface`   | Carbon line receiver interface     | `0.0.0.0` |
| `config.carbon.pickleReceiverInterface` | Carbon pickle receiver interface   | `0.0.0.0` |
| `config.carbon.cacheQueryInterface`     | Carbon cache query interface       | `0.0.0.0` |

### StatsD Configuration

| Parameter                        | Description                        | Default     |
| -------------------------------- | ---------------------------------- | ----------- |
| `config.statsd.enabled`          | Enable StatsD daemon               | `true`      |
| `config.statsd.interface`        | StatsD interface                   | `0.0.0.0`   |
| `config.statsd.flushInterval`    | StatsD flush interval (ms)         | `10000`     |
| `config.statsd.percentThreshold` | StatsD percentile thresholds       | `[90, 95]`  |

### Health Checks

| Parameter                              | Description                            | Default |
| -------------------------------------- | -------------------------------------- | ------- |
| `livenessProbe.enabled`                | Enable liveness probe                  | `true`  |
| `livenessProbe.initialDelaySeconds`    | Initial delay for liveness probe       | `30`    |
| `livenessProbe.periodSeconds`          | Period for liveness probe              | `10`    |
| `livenessProbe.timeoutSeconds`         | Timeout for liveness probe             | `5`     |
| `livenessProbe.failureThreshold`       | Failure threshold for liveness probe   | `3`     |
| `livenessProbe.successThreshold`       | Success threshold for liveness probe   | `1`     |
| `readinessProbe.enabled`               | Enable readiness probe                 | `true`  |
| `readinessProbe.initialDelaySeconds`   | Initial delay for readiness probe      | `5`     |
| `readinessProbe.periodSeconds`         | Period for readiness probe             | `10`    |
| `readinessProbe.timeoutSeconds`        | Timeout for readiness probe            | `5`     |
| `readinessProbe.failureThreshold`      | Failure threshold for readiness probe  | `3`     |
| `readinessProbe.successThreshold`      | Success threshold for readiness probe  | `1`     |

### Node Selection

| Parameter      | Description                      | Default |
| -------------- | -------------------------------- | ------- |
| `nodeSelector` | Node labels for pod assignment   | `{}`    |
| `tolerations`  | Tolerations for pod assignment   | `[]`    |
| `affinity`     | Affinity for pod assignment      | `{}`    |

### Pod Disruption Budget

| Parameter              | Description                          | Default |
| ---------------------- | ------------------------------------ | ------- |
| `pdb.enabled`          | Enable Pod Disruption Budget         | `false` |
| `pdb.minAvailable`     | Minimum number of available pods     | `1`     |
| `pdb.maxUnavailable`   | Maximum number of unavailable pods   | `""`    |

### Extra Objects

| Parameter      | Description                          | Default |
| -------------- | ------------------------------------ | ------- |
| `extraObjects` | Extra objects to deploy with the chart | `[]`  |

## Usage Examples

### Basic Installation

```bash
helm install my-graphite oci://registry-1.docker.io/cloudpirates/graphite
```

### Installation with Persistence

```yaml
# values.yaml
persistence:
  enabled: true
  size: 50Gi
  storageClass: "fast-ssd"
```

```bash
helm install my-graphite oci://registry-1.docker.io/cloudpirates/graphite -f values.yaml
```

### Installation with Ingress

```yaml
# values.yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: graphite.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: graphite-tls
      hosts:
        - graphite.example.com
```

### Custom Storage Schemas

```yaml
# values.yaml
config:
  storage:
    patterns:
      - name: "high-precision"
        pattern: "servers.*"
        retentions: "10s:1d,1m:7d,5m:1y"
      - name: "default"
        pattern: "*"
        retentions: "60s:1d,300s:7d,3600s:1y"
```

### Enabling Monitoring

```yaml
# values.yaml
serviceMonitor:
  enabled: true
  interval: 15s
  labels:
    prometheus: kube-prometheus
```

## Troubleshooting

### Common Issues

1. **Pod not starting**: Check resource limits and persistence configuration
2. **Data not persisting**: Ensure persistence is enabled and PVC is bound
3. **Metrics not appearing**: Verify Carbon port configuration and network policies
4. **High memory usage**: Adjust `config.carbonCacheSize` and resource limits

### Useful Commands

```bash
# Check pod logs
kubectl logs -f deployment/my-graphite

# Check Carbon connectivity
kubectl exec -it deployment/my-graphite -- netstat -tlnp

# Test metric ingestion
kubectl port-forward svc/my-graphite 2003:2003
echo "test.metric 42 $(date +%s)" | nc localhost 2003
```

## Upgrading

To upgrade your Graphite installation:

```bash
helm upgrade my-graphite oci://registry-1.docker.io/cloudpirates/graphite
```

## Uninstalling

To uninstall/delete the deployment:

```bash
helm uninstall my-graphite
```

This will remove all components associated with the chart and delete the release.

## Contributing

Please see [CONTRIBUTING.md](../../CONTRIBUTING.md) for details on how to contribute to this chart.

## License

This chart is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for more information.