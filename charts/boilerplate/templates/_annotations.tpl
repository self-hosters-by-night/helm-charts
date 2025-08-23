{{/*
Common annotations helper template
Usage: {{- include "boilerplate.annotations" (dict "annotations" .Values.annotations "global" .Values.global) | nindent 4 }}
*/}}
{{- define "boilerplate.annotations" -}}
{{- $globalAnnotations := dict }}
{{- if and .global (hasKey .global "annotations") .global.annotations -}}
{{- $globalAnnotations = .global.annotations -}}
{{- end -}}
{{- $annotations := merge $globalAnnotations (.annotations | default dict) -}}
{{- if $annotations }}
annotations:
{{- range $key, $value := $annotations }}
  {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end -}}
