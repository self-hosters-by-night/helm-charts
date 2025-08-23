
{{/*
Security context defaults for
Usage: {{ include "boilerplate.securityContext" ( dict "securityContext" .securityContext "global" .Values.global ) }}
*/}}
{{- define "boilerplate.securityContext" -}}
{{- $globalSecurityContext := dict -}}
{{- if and .global (hasKey .global "securityContext") .global.securityContext -}}
{{- $globalSecurityContext = .global.securityContext -}}
{{- end -}}
{{- $securityContext := mergeOverwrite $globalSecurityContext .securityContext -}}
{{- if $securityContext -}}
securityContext:
  {{- toYaml $securityContext }}
{{- end -}}
{{- end -}}
