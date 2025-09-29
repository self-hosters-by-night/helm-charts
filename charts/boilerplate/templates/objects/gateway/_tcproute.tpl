{{/*
TCPRoute Template
*/}}
{{- define "boilerplate.tcproute.template" -}}
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: {{ include "boilerplate.names.fullname" . }}
  labels:
    {{- include "boilerplate.labels.standard" . | nindent 4 }}
    {{- with .Values.tcpRoute.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.tcpRoute.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- include "boilerplate.tcproute.parentRefs" . | nindent 2 }}
  {{- include "boilerplate.tcproute.rules" . | nindent 2 }}
{{- end }}

{{/*
Parent References
*/}}
{{- define "boilerplate.tcproute.parentRefs" -}}
{{- with .Values.tcpRoute.parentRefs }}
parentRefs:
  {{- toYaml . | nindent 2 }}
{{- else }}
parentRefs:
  - name: {{ .Values.tcpRoute.gateway.name | default "default-gateway" }}
    {{- with .Values.tcpRoute.gateway.namespace }}
    namespace: {{ . }}
    {{- end }}
    {{- with .Values.tcpRoute.gateway.sectionName }}
    sectionName: {{ . }}
    {{- end }}
    {{- with .Values.tcpRoute.gateway.port }}
    port: {{ . }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Rules
*/}}
{{- define "boilerplate.tcproute.rules" -}}
{{- $rules := list }}
{{- with .Values.tcpRoute.defaultRule }}
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
{{- with .Values.tcpRoute.extraRules }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
rules:
  {{- toYaml $rules | nindent 2 }}
{{- end }}
{{- end }}
