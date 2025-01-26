{{/*
Expand the name of the chart.
*/}}
{{- define "simple-postgres.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "simple-postgres.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "simple-postgres.labels" -}}
helm.sh/chart: {{ include "simple-postgres.chart" . }}
{{ include "simple-postgres.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "simple-postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "simple-postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
