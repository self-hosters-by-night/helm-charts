
{{/*
Render extra volume mounts
{{- include "boilerplate.storage.extraVolumeMounts" . }}
*/}}
{{- define "boilerplate.storage.extraVolumeMounts" -}}
{{- if .Values.extraVolumeMounts -}}
{{- range .Values.extraVolumeMounts }}
- name: {{ .name | required "Volume mount name is required" }}
  mountPath: {{ .mountPath | required "Volume mount path is required" }}
{{- with .subPath }}
  subPath: {{ . }}
{{- end }}
{{- with .readOnly }}
  readOnly: {{ . }}
{{- end }}
{{- with .mountPropagation }}
  mountPropagation: {{ . }}
{{- end }}
{{- with .subPathExpr }}
  subPathExpr: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
