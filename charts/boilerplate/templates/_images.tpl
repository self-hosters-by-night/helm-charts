{{/*
Return the proper image name
{{ include "boilerplate.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" .Values.global ) }}
*/}}
{{- define "boilerplate.images.image" -}}
{{- $registryName := default .imageRoot.registry ((.global).imageRegistry) -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $version := include "boilerplate.images.version" . -}}
{{- if $registryName }}
{{- printf "%s/%s%s" $registryName $repositoryName $version -}}
{{- else -}}
{{- printf "%s%s" $repositoryName $version -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image version with separator (tag with : or digest with @, fallbacks to chart appVersion)
{{ include "boilerplate.images.version" ( dict "imageRoot" .Values.path.to.the.image "chart" .Chart ) }}
*/}}
{{- define "boilerplate.images.version" -}}
{{- if .imageRoot.digest }}
{{- printf "@%s" (.imageRoot.digest | toString) -}}
{{- else if .imageRoot.tag }}
{{- $imageTag := .imageRoot.tag | toString -}}
{{- if regexMatch `^v?([0-9]+)(\.[0-9]+)?(\.[0-9]+)?(-([0-9A-Za-z\-]+(\.[0-9A-Za-z\-]+)*))?(\+([0-9A-Za-z\-]+(\.[0-9A-Za-z\-]+)*))?$` $imageTag -}}
{{- printf ":%s" $imageTag -}}
{{- else -}}
{{- printf ":%s" $imageTag -}}
{{- end -}}
{{- else -}}
{{- printf ":%s" .chart.AppVersion -}}
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
