# Kubero Helm Chart

A Helm chart for deploying Kubero - a self-hosted Platform-as-a-Service (PaaS) that allows developers to deploy applications on Kubernetes without specialized knowledge. Kubero provides a Heroku-like experience with GitOps workflows, CI/CD pipelines, and application templates.

## Prerequisites

- Kubernetes 1.24+
- Helm 3.2.0+
- Sufficient cluster resources for both operator and UI components

## Installing the Chart

To install the chart with the release name `my-kubero`:

```bash
helm install my-kubero oci://registry-1.docker.io/cloudpirates/kubero
```

To install with custom values:

```bash
helm install my-kubero oci://registry-1.docker.io/cloudpirates/kubero -f my-values.yaml
```

Or install directly from the local chart:

```bash
helm install my-kubero ./charts/kubero
```

The command deploys Kubero on the Kubernetes cluster in the default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-kubero` deployment:

```bash
helm uninstall my-kubero
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Security & Signature Verification

All CloudPirates Helm charts are signed with [Cosign](https://docs.sigstore.dev/cosign/overview) for supply chain security. You can verify the chart signature:

```bash
cosign verify-blob --key cosign.pub --signature kubero-<version>.tgz.sig kubero-<version>.tgz
```

## Configuration

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imageRegistry` | Global Docker image registry | `""` |
| `global.imagePullSecrets` | Global Docker registry secret names (array) | `[]` |

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | String to partially override kubero.fullname | `""` |
| `fullnameOverride` | String to fully override kubero.fullname | `""` |
| `commonLabels` | Labels to add to all deployed objects | `{}` |
| `commonAnnotations` | Annotations to add to all deployed objects | `{}` |

### Kubero Operator Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.enabled` | Enable deployment of Kubero Operator | `true` |
| `operator.replicaCount` | Number of Kubero Operator replicas to deploy | `1` |
| `operator.image.registry` | Kubero Operator image registry | `ghcr.io` |
| `operator.image.repository` | Kubero Operator image repository | `kubero-dev/kubero-operator/kuberoapp` |
| `operator.image.tag` | Kubero Operator image tag | `v0.1.3` |
| `operator.image.imagePullPolicy` | Kubero Operator image pull policy | `Always` |
| `operator.podAnnotations` | Map of annotations to add to the operator pods | `{}` |
| `operator.podLabels` | Map of labels to add to the operator pods | `{}` |
| `operator.resources.limits.memory` | Memory limit for operator container | `512Mi` |
| `operator.resources.requests.memory` | Memory request for operator container | `256Mi` |
| `operator.resources.requests.cpu` | CPU request for operator container | `100m` |

### Kubero UI Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ui.enabled` | Enable deployment of Kubero UI | `true` |
| `ui.replicaCount` | Number of Kubero UI replicas to deploy | `1` |
| `ui.image.registry` | Kubero UI image registry | `ghcr.io` |
| `ui.image.repository` | Kubero UI image repository | `kubero-dev/kubero` |
| `ui.image.tag` | Kubero UI image tag | `v3.1.1` |
| `ui.image.imagePullPolicy` | Kubero UI image pull policy | `Always` |
| `ui.podAnnotations` | Map of annotations to add to the UI pods | `{}` |
| `ui.podLabels` | Map of labels to add to the UI pods | `{}` |
| `ui.resources.limits.memory` | Memory limit for UI container | `512Mi` |
| `ui.resources.requests.memory` | Memory request for UI container | `256Mi` |
| `ui.resources.requests.cpu` | CPU request for UI container | `100m` |
| `ui.env.KUBERO_NAMESPACE` | Namespace where Kubero operates | `""` |
| `ui.env.KUBERO_SESSION_KEY` | Session key for Kubero UI | `""` |
| `ui.env.KUBERO_WEBHOOK_URL` | Webhook URL for Kubero | `""` |

### Security Context Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `operator.podSecurityContext.enabled` | Enable pod security context for operator | `true` |
| `operator.podSecurityContext.runAsNonRoot` | Run operator container as non-root user | `true` |
| `operator.containerSecurityContext.enabled` | Enable container security context for operator | `true` |
| `operator.containerSecurityContext.readOnlyRootFilesystem` | Enable read-only root filesystem for operator | `true` |
| `operator.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for operator | `false` |
| `ui.podSecurityContext.enabled` | Enable pod security context for UI | `true` |
| `ui.podSecurityContext.runAsNonRoot` | Run UI container as non-root user | `true` |
| `ui.containerSecurityContext.enabled` | Enable container security context for UI | `true` |
| `ui.containerSecurityContext.readOnlyRootFilesystem` | Enable read-only root filesystem for UI | `true` |
| `ui.containerSecurityContext.allowPrivilegeEscalation` | Allow privilege escalation for UI | `false` |

### Service Account Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.name` | The name of the service account to use | `""` |

### RBAC Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `rbac.create` | Specifies whether RBAC resources should be created | `true` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubero UI service type | `ClusterIP` |
| `service.ports` | Service ports configuration | `[{port: 80, targetPort: http, protocol: TCP, name: http}]` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress record generation for Kubero UI | `false` |
| `ingress.className` | IngressClass that will be used to implement the Ingress | `""` |
| `ingress.annotations` | Additional annotations for the Ingress resource | `{}` |
| `ingress.hosts` | An array with the list of hosts for ingress | `[{host: kubero.localhost, paths: [{path: /, pathType: Prefix}]}]` |
| `ingress.tls` | The list of hosts to be covered with this ingress record | `[]` |

### Persistence Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence using Persistent Volume Claims | `false` |
| `persistence.storageClass` | Persistent Volume storage class | `""` |
| `persistence.accessModes` | Persistent Volume access modes | `[ReadWriteOnce]` |
| `persistence.size` | Persistent Volume size | `8Gi` |
| `persistence.annotations` | Additional custom annotations for the PVC | `{}` |

### Node Assignment

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | List of node taints to tolerate | `[]` |
| `affinity` | Affinity for pod assignment | `{}` |

### Pod Disruption Budget

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podDisruptionBudget.enabled` | Enable Pod Disruption Budget | `false` |
| `podDisruptionBudget.minAvailable` | Minimum number/percentage of pods that should remain scheduled | `1` |
| `podDisruptionBudget.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""` |

### Metrics Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `metrics.enabled` | Enable metrics | `false` |
| `metrics.serviceMonitor.enabled` | Create ServiceMonitor resource for scraping metrics using PrometheusOperator | `false` |
| `metrics.serviceMonitor.namespace` | Namespace which Prometheus is running in | `""` |
| `metrics.serviceMonitor.interval` | Interval at which metrics should be scraped | `30s` |

## Examples

### Basic Installation

```bash
helm install kubero oci://registry-1.docker.io/cloudpirates/kubero
```

### Production Setup with Ingress

Create a `values.yaml` file:

```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: kubero.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: kubero-tls
      hosts:
        - kubero.example.com

ui:
  env:
    KUBERO_SESSION_KEY: "your-secure-session-key-here"
    KUBERO_WEBHOOK_URL: "https://kubero.example.com/api/webhook"

resources:
  operator:
    limits:
      memory: 1Gi
    requests:
      cpu: 200m
      memory: 512Mi
  ui:
    limits:
      memory: 1Gi
    requests:
      cpu: 200m
      memory: 512Mi

podDisruptionBudget:
  enabled: true
  minAvailable: 1
```

Install the chart:

```bash
helm install kubero oci://registry-1.docker.io/cloudpirates/kubero -f values.yaml
```

### High Availability Setup

```yaml
operator:
  replicaCount: 2

ui:
  replicaCount: 2

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - kubero
          topologyKey: kubernetes.io/hostname

podDisruptionBudget:
  enabled: true
  minAvailable: 1
```

### Security-Hardened Deployment

```yaml
operator:
  podSecurityContext:
    enabled: true
    runAsNonRoot: true
    runAsUser: 65534
    runAsGroup: 65534
    fsGroup: 65534
  containerSecurityContext:
    enabled: true
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL

ui:
  podSecurityContext:
    enabled: true
    runAsNonRoot: true
    runAsUser: 65534
    runAsGroup: 65534
    fsGroup: 65534
  containerSecurityContext:
    enabled: true
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL

networkPolicy:
  enabled: true
```

## Access Kubero

After installation, you can access Kubero UI through:

1. **Port Forward** (development):
   ```bash
   kubectl port-forward svc/kubero-ui 8080:80
   ```
   Then visit http://localhost:8080

2. **Ingress** (production):
   Configure ingress as shown in the examples above and access via your domain.

3. **LoadBalancer** (cloud environments):
   Set `service.type: LoadBalancer` and access via the external IP.

## What is Kubero?

Kubero is a self-hosted Platform-as-a-Service (PaaS) that brings the simplicity of Heroku to your Kubernetes cluster. Key features include:

### 🚀 **Application Deployment**
- Deploy applications from Git repositories with zero Kubernetes knowledge
- Support for multiple languages and frameworks (Node.js, Python, PHP, Go, etc.)
- Automatic build and deployment pipelines

### 🔄 **GitOps Workflows**
- Automatic deployments on git push
- Review apps for pull requests
- Multiple deployment environments (development, staging, production)

### 📋 **Application Templates**
- 160+ pre-built application templates
- One-click deployment of popular applications (WordPress, Grafana, etc.)
- Custom template support

### 🔧 **Add-ons Integration**
- Built-in database support (PostgreSQL, MySQL, MongoDB, Redis)
- Service discovery and configuration management
- External service integrations

### 📊 **Management & Monitoring**
- Web-based UI for application management
- Application logs and metrics
- Health monitoring and alerts

## Architecture

Kubero consists of two main components:

1. **Kubero Operator**: Manages the Kubernetes resources and handles application lifecycle
2. **Kubero UI**: Provides the web interface for managing applications and pipelines

The operator watches for Custom Resources and translates them into standard Kubernetes objects, while the UI provides an intuitive interface for developers to manage their applications.

## Troubleshooting

### Common Issues

1. **Operator not starting**:
   ```bash
   kubectl logs -l app.kubernetes.io/component=operator -n <namespace>
   ```

2. **UI not accessible**:
   ```bash
   kubectl get svc -l app.kubernetes.io/component=ui -n <namespace>
   kubectl get ingress -n <namespace>
   ```

3. **RBAC permissions issues**:
   Ensure the service account has the necessary cluster permissions for the operator.

### Getting Help

- [Kubero Documentation](https://www.kubero.dev/docs/)
- [GitHub Issues](https://github.com/kubero-dev/kubero/issues)
- [Discord Community](https://discord.gg/tafRPMWS4r)

## Contributing

This chart is maintained by CloudPirates. For chart-specific issues, please open an issue in the [CloudPirates Helm Charts repository](https://github.com/CloudPirates-io/helm-charts).

For Kubero-specific issues, please use the [main Kubero repository](https://github.com/kubero-dev/kubero).

## License

This Helm chart is licensed under the Apache 2.0 License. Kubero itself is licensed under the GPL-3.0 License.