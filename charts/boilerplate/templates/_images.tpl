{{/*
Return the proper image name
{{ include "boilerplate.images.image" . }}
*/}}
{{- define "boilerplate.images.image" -}}
{{- $registryName := default .image.registry ($.Values.global.imageRegistry) -}}
{{- $repositoryName := .image.repository -}}
{{- $version := include "boilerplate.images.version" . -}}
{{- if $registryName }}
{{- printf "%s/%s%s" $registryName $repositoryName $version -}}
{{- else -}}
{{- printf "%s%s" $repositoryName $version -}}
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
{{ include "boilerplate.images.validate" .Values.path.to.the.image }}
*/}}
{{- define "boilerplate.images.validate" -}}
{{- if not .repository -}}
{{- fail "Image repository is required" -}}
{{- end -}}
{{- if and (not .tag) (not .digest) -}}
{{- fail "Either image tag or digest must be specified" -}}
{{- end -}}
{{- end -}}
