{{/*
HTTPRoute Template
*/}}
{{- define "boilerplate.httproute.template" -}}
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: {{ include "boilerplate.names.fullname" . }}
  labels:
    {{- include "boilerplate.labels.standard" . | nindent 4 }}
    {{- with .Values.httpRoute.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.httpRoute.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- include "boilerplate.httproute.parentRefs" . | nindent 2 }}
  {{- include "boilerplate.httproute.hostnames" . | nindent 2 }}
  {{- include "boilerplate.httproute.rules" . | nindent 2 }}
{{- end }}

{{/*
Parent References
*/}}
{{- define "boilerplate.httproute.parentRefs" -}}
{{- with .Values.httpRoute.parentRefs }}
parentRefs:
  {{- toYaml . | nindent 2 }}
{{- else }}
parentRefs:
  - name: {{ .Values.httpRoute.gateway.name }}
    {{- with .Values.httpRoute.gateway.namespace }}
    namespace: {{ . }}
    {{- end }}
    {{- with .Values.httpRoute.gateway.sectionName }}
    sectionName: {{ . }}
    {{- end }}
    {{- with .Values.httpRoute.gateway.port }}
    port: {{ . }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Hostnames
*/}}
{{- define "boilerplate.httproute.hostnames" -}}
{{- with .Values.httpRoute.hostnames }}
hostnames:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Rules
*/}}
{{- define "boilerplate.httproute.rules" -}}
{{- $rules := list }}
{{- with .Values.httpRoute.defaultRule }}
{{- if .enabled }}
{{- $rule := dict }}
{{- with .matches }}{{ $rule = set $rule "matches" . }}{{- end }}
{{- with .filters }}{{ $rule = set $rule "filters" . }}{{- end }}
{{- with .backendRefs }}
{{ $rule = set $rule "backendRefs" . }}
{{- else }}
{{- $backendRef := dict "name" (include "boilerplate.names.fullname" $) "port" (.port | default 80) }}
{{- with .weight }}{{ $backendRef = set $backendRef "weight" . }}{{- end }}
{{ $rule = set $rule "backendRefs" (list $backendRef) }}
{{- end }}
{{- $rules = append $rules $rule }}
{{- end }}
{{- end }}
{{- with .Values.httpRoute.extraRules }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
rules:
  {{- toYaml $rules | nindent 2 }}
{{- end }}
{{- end }}
