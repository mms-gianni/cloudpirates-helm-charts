# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-16

### Added

- Initial release of Graphite Helm chart
- Support for Graphite web interface on port 8080
- Carbon receiver support (plaintext and pickle protocols)
- Carbon aggregator support
- StatsD daemon integration
- Configurable storage schemas and retention policies
- Persistent volume support for Graphite data
- Kubernetes Ingress support for web interface
- ServiceMonitor support for Prometheus monitoring
- Pod Disruption Budget support
- Health checks (liveness and readiness probes)
- Comprehensive configuration options
- Security contexts for enhanced security
- Resource management and limits
- Node selection, tolerations, and affinity support
- Extra objects support for custom resources