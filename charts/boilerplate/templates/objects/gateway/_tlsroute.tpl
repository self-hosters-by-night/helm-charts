{{/*
TLSRoute Template
*/}}
{{- define "boilerplate.tlsroute.template" -}}
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TLSRoute
metadata:
  name: {{ include "boilerplate.names.fullname" . }}
  labels:
    {{- include "boilerplate.labels.standard" . | nindent 4 }}
    {{- with .Values.tlsRoute.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.tlsRoute.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- include "boilerplate.tlsroute.parentRefs" . | nindent 2 }}
  {{- include "boilerplate.tlsroute.hostnames" . | nindent 2 }}
  {{- include "boilerplate.tlsroute.rules" . | nindent 2 }}
{{- end }}

{{/*
Parent References
*/}}
{{- define "boilerplate.tlsroute.parentRefs" -}}
{{- with .Values.tlsRoute.parentRefs }}
parentRefs:
  {{- toYaml . | nindent 2 }}
{{- else }}
parentRefs:
  - name: {{ .Values.tlsRoute.gateway.name | default "default-gateway" }}
    {{- with .Values.tlsRoute.gateway.namespace }}
    namespace: {{ . }}
    {{- end }}
    {{- with .Values.tlsRoute.gateway.sectionName }}
    sectionName: {{ . }}
    {{- end }}
    {{- with .Values.tlsRoute.gateway.port }}
    port: {{ . }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Hostnames
*/}}
{{- define "boilerplate.tlsroute.hostnames" -}}
{{- with .Values.tlsRoute.hostnames }}
hostnames:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Rules
*/}}
{{- define "boilerplate.tlsroute.rules" -}}
{{- $rules := list }}
{{- with .Values.tlsRoute.defaultRule }}
{{- if .enabled }}
{{- $rule := dict }}
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
{{- with .Values.tlsRoute.extraRules }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
rules:
  {{- toYaml $rules | nindent 2 }}
{{- end }}
{{- end }}
