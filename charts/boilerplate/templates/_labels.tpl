{{/*
Standard labels
*/}}
{{- define "boilerplate.labels.standard" -}}
app.kubernetes.io/name: {{ include "boilerplate.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- with .Chart.AppVersion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "boilerplate.names.chart" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "boilerplate.labels.selectorLabels" -}}
app.kubernetes.io/name: {{ include "boilerplate.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
