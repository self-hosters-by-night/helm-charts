{{/*
Render extra objects
Usage:
{{- include "boilerplate.render.extraObjects"
  ( dict
    "root" $
    "extraObjects" .Values.path.to.extraObjects
  )
}}
*/}}
{{- define "boilerplate.render.extraObjects" -}}
{{- $root := .root -}}
{{- range $object := .extraObjects }}
---
{{ tpl ( $object | toYaml ) $root }}
{{- end }}
{{- end }}
