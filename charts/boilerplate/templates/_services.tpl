{{/*
Validate service configuration
{{ include "boilerplate.service.validate" .Values.service }}
*/}}
{{- define "boilerplate.service.validate" -}}
{{- $validTypes := list "ClusterIP" "NodePort" "LoadBalancer" "ExternalName" }}
{{- if not (has .type $validTypes) }}
{{- fail (printf "service.type must be one of: %s" (join "," $validTypes)) }}
{{- end }}
{{- if and (eq .type "LoadBalancer") .loadBalancerIP (not (regexMatch "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$" .loadBalancerIP)) }}
{{- fail "service.loadBalancerIP must be a valid IP address" }}
{{- end }}
{{- end -}}
