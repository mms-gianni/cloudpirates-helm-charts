# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-20

### Added
- Initial release of Kubero Helm chart
- Support for deploying Kubero Operator (v0.1.3)
- Support for deploying Kubero UI (v3.1.1)
- Complete RBAC configuration with ClusterRole and ClusterRoleBinding
- Service account creation and management
- Configurable security contexts following security best practices
- Ingress support with TLS configuration
- Pod Disruption Budget support
- Comprehensive configuration options for both operator and UI components
- Health check probes for both components
- Resource management and limits
- Node assignment options (nodeSelector, tolerations, affinity)
- Support for common labels and annotations
- Metrics configuration with ServiceMonitor support
- Extra objects template for additional Kubernetes resources
- Complete documentation with examples
- Helm unit tests for template validation
- CI/CD integration support

### Security
- Read-only root filesystem enabled by default
- Non-root user execution
- Dropped all Linux capabilities
- No privilege escalation allowed
- Security contexts properly configured