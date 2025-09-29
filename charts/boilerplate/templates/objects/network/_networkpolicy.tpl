
{{/*
Standard Network Policy Template
*/}}
{{- define "boilerplate.networkpolicy.template" -}}
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ .Values.networkPolicy.name }}
  labels:
    {{- include "boilerplate.labels.standard" . | nindent 4 }}
    {{- with .Values.networkPolicy.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.networkPolicy.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  podSelector:
    {{- include "boilerplate.networkpolicy.podSelector" . | nindent 4 }}
  {{- include "boilerplate.networkpolicy.policyTypes" . | nindent 2 }}
  {{- include "boilerplate.networkpolicy.ingress" . | nindent 2 }}
  {{- include "boilerplate.networkpolicy.egress" . | nindent 2 }}
{{- end }}

{{/*
Pod Selector
*/}}
{{- define "boilerplate.networkpolicy.podSelector" -}}
{{- .Values.networkPolicy.podSelector | default (dict "matchLabels" (include "boilerplate.labels.selectorLabels" . | fromYaml)) | toYaml }}
{{- end }}

{{/*
Policy Types
*/}}
{{- define "boilerplate.networkpolicy.policyTypes" -}}
{{- $types := list }}
{{- if or .Values.networkPolicy.defaultIngress.enabled .Values.networkPolicy.extraIngress }}
{{- $types = append $types "Ingress" }}
{{- end }}
{{- if or .Values.networkPolicy.defaultEgress.enabled .Values.networkPolicy.extraEgress }}
{{- $types = append $types "Egress" }}
{{- end }}
{{- if $types }}
policyTypes: {{ $types | toYaml | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Egress Rules
*/}}
{{- define "boilerplate.networkpolicy.egress" -}}
{{- $rules := list }}
{{- with .Values.networkPolicy.defaultEgress }}
{{- if .enabled }}
{{- $rule := dict }}
{{- with .to }}{{ $rule = set $rule "to" . }}{{- end }}
{{- with .ports }}{{ $rule = set $rule "ports" . }}{{- end }}
{{- $rules = append $rules $rule }}
{{- end }}
{{- end }}
{{- with .Values.networkPolicy.extraEgress }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
egress: {{ $rules | toYaml | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Ingress Rules
*/}}
{{- define "boilerplate.networkpolicy.ingress" -}}
{{- $rules := list }}
{{- with .Values.networkPolicy.defaultIngress }}
{{- if .enabled }}
{{- $rule := dict }}
{{- with .from }}{{ $rule = set $rule "from" . }}{{- end }}
{{- with .ports }}{{ $rule = set $rule "ports" . }}{{- end }}
{{- $rules = append $rules $rule }}
{{- end }}
{{- end }}
{{- with .Values.networkPolicy.extraIngress }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
ingress: {{ $rules | toYaml | nindent 0 }}
{{- end }}
{{- end }}
