{{/*
Expand the name of the chart.
*/}}
{{- define "graphite.name" -}}
{{- include "cloudpirates.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "graphite.fullname" -}}
{{- include "cloudpirates.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "graphite.chart" -}}
{{- include "cloudpirates.chart" . -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "graphite.labels" -}}
{{- include "cloudpirates.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "graphite.selectorLabels" -}}
{{- include "cloudpirates.selectorLabels" . -}}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "graphite.annotations" -}}
{{- include "cloudpirates.annotations" . -}}
{{- end }}

{{/*
Return the proper Graphite image name
*/}}
{{- define "graphite.image" -}}
{{- include "cloudpirates.image" (dict "image" .Values.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "graphite.imagePullSecrets" -}}
{{ include "cloudpirates.images.renderPullSecrets" (dict "images" (list .Values.image) "context" .) }}
{{- end -}}

{{/*
Return the Graphite service account name
*/}}
{{- define "graphite.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "graphite.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper persistent volume claim name
*/}}
{{- define "graphite.claimName" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else }}
{{- include "graphite.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the Graphite configuration ConfigMap name
*/}}
{{- define "graphite.configMapName" -}}
{{- if .Values.config.existingConfigMap }}
{{- .Values.config.existingConfigMap }}
{{- else }}
{{- include "graphite.fullname" . }}-config
{{- end }}
{{- end }}

{{/*
Generate storage patterns configuration
*/}}
{{- define "graphite.storagePatterns" -}}
{{- range $index, $pattern := .Values.config.storage.patterns }}
[{{ $pattern.name }}]
pattern = {{ $pattern.pattern }}
retentions = {{ $pattern.retentions }}
{{- if not (eq $index (sub (len $.Values.config.storage.patterns) 1)) }}

{{- end }}
{{- end }}
{{- end -}}

{{/*
Generate Carbon configuration
*/}}
{{- define "graphite.carbonConfig" -}}
[cache]
CARBON_CACHE_SIZE = {{ .Values.config.carbonCacheSize }}
MAX_CREATES_PER_MINUTE = {{ .Values.config.maxCreatesPerMinute }}
MAX_UPDATES_PER_SECOND = {{ .Values.config.maxUpdatesPerSecond }}
LINE_RECEIVER_INTERFACE = {{ .Values.config.carbon.lineReceiverInterface }}
LINE_RECEIVER_PORT = {{ .Values.ports.carbon }}
PICKLE_RECEIVER_INTERFACE = {{ .Values.config.carbon.pickleReceiverInterface }}
PICKLE_RECEIVER_PORT = {{ .Values.ports.carbonPickle }}
CACHE_QUERY_INTERFACE = {{ .Values.config.carbon.cacheQueryInterface }}
CACHE_QUERY_PORT = 7002
ENABLE_UDP_LISTENER = {{ if .Values.config.carbon.enableUdp }}True{{ else }}False{{ end }}
UDP_RECEIVER_INTERFACE = {{ .Values.config.carbon.lineReceiverInterface }}
UDP_RECEIVER_PORT = {{ .Values.ports.carbon }}
LOG_LEVEL = {{ .Values.config.logLevel }}
ENABLE_LOGROTATION = {{ if .Values.config.enableLogRotation }}True{{ else }}False{{ end }}
WHISPER_AUTOFLUSH = {{ if .Values.config.whisperAutoflush }}True{{ else }}False{{ end }}

[aggregator]
LINE_RECEIVER_INTERFACE = 0.0.0.0
LINE_RECEIVER_PORT = {{ .Values.ports.carbonAggregator }}
PICKLE_RECEIVER_INTERFACE = 0.0.0.0
PICKLE_RECEIVER_PORT = 2024
LOG_LEVEL = {{ .Values.config.logLevel }}
{{- end -}}

{{/*
Generate StatsD configuration
*/}}
{{- define "graphite.statsdConfig" -}}
{
  "address": "{{ .Values.config.statsd.interface }}",
  "port": {{ .Values.ports.statsd }},
  "mgmt_address": "{{ .Values.config.statsd.interface }}",
  "mgmt_port": 8126,
  "title": "statsd",
  "flushInterval": {{ .Values.config.statsd.flushInterval }},
  "percentThreshold": {{ .Values.config.statsd.percentThreshold | toJson }},
  "backends": ["./backends/graphite"],
  "graphite": {
    "host": "localhost",
    "port": {{ .Values.ports.carbon }}
  }
}
{{- end -}}