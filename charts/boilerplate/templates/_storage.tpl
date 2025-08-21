{{/*
Render extra volumes
{{ include "boilerplate.storage.extraVolumes" . }}
*/}}
{{- define "boilerplate.storage.extraVolumes" -}}
{{- if .Values.extraVolumes -}}
{{- range .Values.extraVolumes }}
- name: {{ .name | required "Volume name is required" }}
{{- if .configMap }}
  configMap:
    name: {{ .configMap.name | required "ConfigMap name is required" }}
{{- with .configMap.defaultMode }}
    defaultMode: {{ . }}
{{- end }}
{{- with .configMap.items }}
    items:
{{- range . }}
    - key: {{ .key | required "ConfigMap item key is required" }}
      path: {{ .path | required "ConfigMap item path is required" }}
{{- with .mode }}
      mode: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- else if .secret }}
  secret:
    secretName: {{ .secret.secretName | required "Secret name is required" }}
{{- with .secret.defaultMode }}
    defaultMode: {{ . }}
{{- end }}
{{- with .secret.items }}
    items:
{{- range . }}
    - key: {{ .key | required "Secret item key is required" }}
      path: {{ .path | required "Secret item path is required" }}
{{- with .mode }}
      mode: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- else if .persistentVolumeClaim }}
  persistentVolumeClaim:
    claimName: {{ .persistentVolumeClaim.claimName | required "PVC claim name is required" }}
{{- with .persistentVolumeClaim.readOnly }}
    readOnly: {{ . }}
{{- end }}
{{- else if .emptyDir }}
  emptyDir:
{{- with .emptyDir.sizeLimit }}
    sizeLimit: {{ . }}
{{- end }}
{{- with .emptyDir.medium }}
    medium: {{ . }}
{{- end }}
{{- else if .hostPath }}
  hostPath:
    path: {{ .hostPath.path | required "HostPath path is required" }}
{{- with .hostPath.type }}
    type: {{ . }}
{{- end }}
{{- else }}
{{- fail "Volume type must be specified (configMap, secret, persistentVolumeClaim, emptyDir or hostPath)" }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Render extra volume mounts
{{ include "boilerplate.storage.extraVolumeMounts" . }}
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
