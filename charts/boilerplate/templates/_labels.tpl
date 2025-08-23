{{/*
Standard labels
{{- include "boilerplate.labels.standard" . | nindent 4 }}
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
{{- include "boilerplate.labels.selectorLabels" . | nindent 6 }}
*/}}
{{- define "boilerplate.labels.selectorLabels" -}}
app.kubernetes.io/name: {{ include "boilerplate.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels combining standard labels with custom pod labels
{{- include "boilerplate.labels.podLabels" . | nindent 8 }}
*/}}
{{- define "boilerplate.labels.podLabels" -}}
{{- include "boilerplate.labels.standard" . }}
{{- with .Values.podLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Common labels helper template
Usage: {{- include "boilerplate.labels" (dict "labels" .Values.labels "global" .Values.global) | nindent 4 }}
*/}}
{{- define "boilerplate.labels" -}}
{{- $globalLabels := dict }}
{{- if and .global (hasKey .global "labels") .global.labels -}}
{{- $globalLabels = .global.labels -}}
{{- end -}}
{{- $labels := merge $globalLabels (.labels | default dict) -}}
{{- if $labels }}
labels:
{{- range $key, $value := $labels }}
  {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end -}}
