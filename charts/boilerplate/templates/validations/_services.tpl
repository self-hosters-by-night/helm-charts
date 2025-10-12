{{/*
Validate service configuration
{{ include "boilerplate.service.validate" .Values.service }}
*/}}
{{- define "boilerplate.service.validate" -}}
{{- $validTypes := list "ClusterIP" "NodePort" "LoadBalancer" "ExternalName" -}}
{{- if not (has .type $validTypes) -}}
{{- fail (printf "service.type must be one of: %s" (join ", " $validTypes)) -}}
{{- end -}}
{{- if and (eq .type "LoadBalancer") .loadBalancerIP -}}
{{- if not (regexMatch "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$" .loadBalancerIP) -}}
{{- fail "service.loadBalancerIP must be a valid IPv4 address" -}}
{{- end -}}
{{- end -}}
{{- if and (eq .type "NodePort") .port -}}
{{- if or (lt (.port | int) 30000) (gt (.port | int) 32767) -}}
{{- fail "service.port for NodePort must be between 30000-32767" -}}
{{- end -}}
{{- end -}}
{{- if eq .type "ExternalName" -}}
{{- if not .externalName -}}
{{- fail "service.externalName is required when type is ExternalName" -}}
{{- end -}}
{{- end -}}
{{- end -}}
