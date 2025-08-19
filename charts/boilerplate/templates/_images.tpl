{{/*
Return the proper image name
{{ include "boilerplate.images.image" . }}
*/}}
{{- define "boilerplate.images.image" -}}
{{- $registry := default .image.registry ($.Values.global.imageRegistry) -}}
{{- $repository := .image.repository -}}
{{- $version := include "boilerplate.images.version" . -}}
{{- if $registry }}
{{- printf "%s/%s%s" $registry $repository $version -}}
{{- else -}}
{{- printf "%s%s" $repository $version -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image version. Falls back to Chart.AppVersion if no tag or digest is specified.
{{ include "boilerplate.images.version" . }}
*/}}
{{- define "boilerplate.images.version" -}}
{{- if .image.digest }}
{{- printf "@%s" (.image.digest | toString) -}}
{{- else if .image.tag }}
{{- printf ":%s" (.image.tag | toString) -}}
{{- else -}}
{{- printf ":%s" $.Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Validate image configuration
{{ include "boilerplate.images.validate" . }}
*/}}
{{- define "boilerplate.images.validate" -}}
{{- if not .repository -}}
{{- fail "Image repository is required" -}}
{{- end -}}
{{- if and (not .tag) (not .digest) -}}
{{- fail "Either image tag or digest must be specified" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image pull policy
{{ include "boilerplate.images.pullPolicy" . }}
*/}}
{{- define "boilerplate.images.pullPolicy" -}}
{{- default .image.pullPolicy ($.Values.global.imagePullPolicy) | default "IfNotPresent" -}}
{{- end -}}

{{/*
Return the proper image pull secrets
{{ include "boilerplate.images.pullSecrets" . }}
*/}}
{{- define "boilerplate.images.pullSecrets" -}}
{{- $pullSecrets := list -}}
{{- if $.Values.global.imagePullSecrets -}}
{{- $pullSecrets = concat $pullSecrets $.Values.global.imagePullSecrets -}}
{{- end -}}
{{- if .image.pullSecrets -}}
{{- $pullSecrets = concat $pullSecrets .image.pullSecrets -}}
{{- end -}}
{{- if $pullSecrets -}}
imagePullSecrets:
{{- range $pullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}
