{{/*
Expand the name of the chart.
*/}}
{{- define "kubero.name" -}}
{{- include "cloudpirates.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubero.fullname" -}}
{{- include "cloudpirates.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubero.chart" -}}
{{- include "cloudpirates.chart" . -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubero.labels" -}}
{{- include "cloudpirates.labels" . -}}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "kubero.annotations" -}}
{{- with .Values.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kubero.selectorLabels" -}}
{{- include "cloudpirates.selectorLabels" . -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubero.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kubero.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper Kubero Operator image name
*/}}
{{- define "kubero.operator.image" -}}
{{- include "cloudpirates.image" (dict "image" .Values.operator.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Kubero UI image name
*/}}
{{- define "kubero.ui.image" -}}
{{- include "cloudpirates.image" (dict "image" .Values.ui.image "global" .Values.global) -}}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kubero.imagePullSecrets" -}}
{{- include "cloudpirates.images.renderPullSecrets" (dict "images" (list .Values.operator.image .Values.ui.image) "context" .) -}}
{{- end }}

{{/*
Create operator fullname
*/}}
{{- define "kubero.operator.fullname" -}}
{{- printf "%s-operator" (include "kubero.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create UI fullname
*/}}
{{- define "kubero.ui.fullname" -}}
{{- printf "%s-ui" (include "kubero.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create operator selector labels
*/}}
{{- define "kubero.operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubero.name" . }}-operator
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: operator
{{- end }}

{{/*
Create UI selector labels
*/}}
{{- define "kubero.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubero.name" . }}-ui
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: ui
{{- end }}

{{/*
Create operator labels
*/}}
{{- define "kubero.operator.labels" -}}
{{ include "kubero.labels" . }}
{{ include "kubero.operator.selectorLabels" . }}
{{- end }}

{{/*
Create UI labels
*/}}
{{- define "kubero.ui.labels" -}}
{{ include "kubero.labels" . }}
{{ include "kubero.ui.selectorLabels" . }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kubero.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end }}