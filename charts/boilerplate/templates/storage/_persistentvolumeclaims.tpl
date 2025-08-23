{{/*
Generate PersistentVolumeClaim manifest
Usage:
{{- include "boilerplate.storage.pvc" (dict
  "name" "my-pvc"
  "namespace" "default"
  "storageClass" "nfs-client"
  "storage" "10Gi"
  "accessModes" (list "ReadWriteOnce")
  "annotations" (dict "example.com/annotation" "value")
  "labels" (dict "app" "myapp")
  "volumeName" "my-pv"
  "selector" (dict "matchLabels" (dict "app" "myapp"))
  "global" .Values.global
) }}
*/}}
{{- define "boilerplate.storage.pvc" -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ required "PVC name is required" .name }}
  namespace: {{ .namespace | default .Release.namespace }}
  {{- include "boilerplate.annotations" (dict "annotations" .annotations "global" .global) | nindent 2 }}
  {{- include "boilerplate.labels" (dict "labels" .labels "global" .global) | nindent 2 }}
spec:
  {{- if .storageClass }}
  storageClassName: {{ .storageClass | quote }}
  {{- else if hasKey . "storageClass" }}
  storageClassName: ""
  {{- end }}
  {{- if .volumeName }}
  volumeName: {{ .volumeName }}
  {{- end }}
  accessModes:
    {{- if .accessModes }}
    {{- toYaml .accessModes | nindent 4 }}
    {{- else }}
    - ReadWriteOnce
    {{- end }}
  resources:
    requests:
      storage: {{ .storage | default "1Gi" }}
    {{- if .limits }}
    limits:
      storage: {{ .limits }}
    {{- end }}
  {{- if .selector }}
  selector:
    {{- toYaml .selector | nindent 4 }}
  {{- end }}
  {{- if .dataSource }}
  dataSource:
    {{- toYaml .dataSource | nindent 4 }}
  {{- end }}
  {{- if .dataSourceRef }}
  dataSourceRef:
    {{- toYaml .dataSourceRef | nindent 4 }}
  {{- end }}
{{- end -}}

{{/*
Generate multiple PVCs from a list
Usage:
{{- include "boilerplate.storage.pvcs" (dict
  "pvcs" (list
    (dict "name" "pvc1" "storage" "5Gi")
    (dict "name" "pvc2" "storage" "10Gi" "accessModes" (list "ReadWriteMany"))
  )
  "defaults" (dict "storageClass" "nfs-client" "accessModes" (list "ReadWriteOnce"))
  "global" .Values.global
) }}
*/}}
{{- define "boilerplate.storage.pvcs" -}}
{{- range .pvcs }}
---
{{- $pvc := merge . $.defaults }}
{{- include "boilerplate.storage.pvc" (merge $pvc (dict "global" $.global)) }}
{{- end }}
{{- end -}}
