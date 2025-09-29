{{/*
UDPRoute Template
*/}}
{{- define "boilerplate.udproute.template" -}}
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: UDPRoute
metadata:
  name: {{ include "boilerplate.names.fullname" . }}
  labels:
    {{- include "boilerplate.labels.standard" . | nindent 4 }}
    {{- with .Values.udpRoute.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.udpRoute.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- include "boilerplate.udproute.parentRefs" . | nindent 2 }}
  {{- include "boilerplate.udproute.rules" . | nindent 2 }}
{{- end }}

{{/*
Parent References
*/}}
{{- define "boilerplate.udproute.parentRefs" -}}
{{- with .Values.udpRoute.parentRefs }}
parentRefs:
  {{- toYaml . | nindent 2 }}
{{- else }}
parentRefs:
  - name: {{ .Values.udpRoute.gateway.name | default "default-gateway" }}
    {{- with .Values.udpRoute.gateway.namespace }}
    namespace: {{ . }}
    {{- end }}
    {{- with .Values.udpRoute.gateway.sectionName }}
    sectionName: {{ . }}
    {{- end }}
    {{- with .Values.udpRoute.gateway.port }}
    port: {{ . }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Rules
*/}}
{{- define "boilerplate.udproute.rules" -}}
{{- $rules := list }}
{{- with .Values.udpRoute.defaultRule }}
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
{{- with .Values.udpRoute.extraRules }}
{{- $rules = concat $rules . }}
{{- end }}
{{- if $rules }}
rules:
  {{- toYaml $rules | nindent 2 }}
{{- end }}
{{- end }}
