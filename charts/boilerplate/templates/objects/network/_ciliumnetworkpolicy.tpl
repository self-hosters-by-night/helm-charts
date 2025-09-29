
{{/*
Cilium Network Policy Template
*/}}
{{- define "boilerplate.ciliumnetworkpolicy.template" -}}
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: {{ .Values.ciliumNetworkPolicy.name . }}
  labels:
    {{- include "boilerplate.labels.standard" . | nindent 4 }}
    {{- with .Values.ciliumNetworkPolicy.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.ciliumNetworkPolicy.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  endpointSelector:
    {{- include "boilerplate.ciliumnetworkpolicy.endpointSelector" . | nindent 4 }}
  {{- include "boilerplate.ciliumnetworkpolicy.ingress" . | nindent 2 }}
  {{- include "boilerplate.ciliumnetworkpolicy.egress" . | nindent 2 }}
{{- end }}

{{/*
Endpoint Selector
*/}}
{{- define "boilerplate.ciliumnetworkpolicy.endpointSelector" -}}
{{- .Values.ciliumNetworkPolicy.endpointSelector | default (dict "matchLabels" (include "boilerplate.labels.selectorLabels" . | fromYaml)) | toYaml }}
{{- end }}

{{/*
Egress Rules
*/}}
{{- define "boilerplate.ciliumnetworkpolicy.egress" -}}
{{- $rules := list }}
{{- with .Values.ciliumNetworkPolicy.defaultEgress }}
{{- if .enabled }}
{{- $rule := dict }}
{{- with .toEndpoints }}{{ $rule = set $rule "toEndpoints" . }}{{- end }}
{{- with .toEntities }}{{ $rule = set $rule "toEntities" . }}{{- end }}
{{- with .toCIDR }}{{ $rule = set $rule "toCIDR" . }}{{- end }}
{{- with .toFQDNs }}{{ $rule = set $rule "toFQDNs" . }}{{- end }}
{{- with .toPorts }}{{ $rule = set $rule "toPorts" . }}{{- end }}
{{- with .toServices }}{{ $rule = set $rule "toServices" . }}{{- end }}
{{- with .icmps }}{{ $rule = set $rule "icmps" . }}{{- end }}
{{- $rules = append $rules $rule }}
{{- end }}
{{- end }}
{{- with .Values.ciliumNetworkPolicy.extraEgress }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
egress: {{ $rules | toYaml | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Ingress Rules
*/}}
{{- define "boilerplate.ciliumnetworkpolicy.ingress" -}}
{{- $rules := list }}
{{- with .Values.ciliumNetworkPolicy.defaultIngress }}
{{- if .enabled }}
{{- $rule := dict }}
{{- with .fromEndpoints }}{{ $rule = set $rule "fromEndpoints" . }}{{- end }}
{{- with .fromEntities }}{{ $rule = set $rule "fromEntities" . }}{{- end }}
{{- with .fromCIDR }}{{ $rule = set $rule "fromCIDR" . }}{{- end }}
{{- with .fromFQDNs }}{{ $rule = set $rule "fromFQDNs" . }}{{- end }}
{{- with .toPorts }}{{ $rule = set $rule "toPorts" . }}{{- end }}
{{- with .icmps }}{{ $rule = set $rule "icmps" . }}{{- end }}
{{- $rules = append $rules $rule }}
{{- end }}
{{- end }}
{{- with .Values.ciliumNetworkPolicy.extraIngress }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
ingress: {{ $rules | toYaml | nindent 0 }}
{{- end }}
{{- end }}
