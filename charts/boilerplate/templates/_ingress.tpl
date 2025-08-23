{{/*
Validate ingress configuration
{{ include "boilerplate.ingress.validate" .Values.ingress }}
*/}}
{{- define "boilerplate.ingress.validate" -}}
{{- if .enabled }}
{{- if not .hosts }}
{{- fail "ingress.hosts is required when ingress is enabled" }}
{{- end }}
{{- range .hosts }}
{{- if not .host }}
{{- fail "ingress.hosts[].host is required" }}
{{- end }}
{{- range .paths }}
{{- if not .path }}
{{- fail "ingress.hosts[].paths[].path is required" }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
