{{/*
Return the proper image name
{{ include "boilerplate.images.image" ( dict "image" .Values.path.to.the.image "global" .Values.global "chart" .Chart ) }}
*/}}
{{- define "boilerplate.images.image" -}}
{{- $globalRegistry := (.global.imageRegistry) | default "" -}}
{{- $registry := coalesce .image.registry $globalRegistry "" -}}
{{- $repository := .image.repository -}}
{{- $version := include "boilerplate.images.version" . -}}
{{- if $registry }}
{{- printf "%s/%s%s" $registry $repository $version -}}
{{- else -}}
{{- printf "%s%s" $repository $version -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image version. Falls back to Chart.appVersion if no tag or digest is specified.
{{ include "boilerplate.images.version" . }}
*/}}
{{- define "boilerplate.images.version" -}}
{{- if .image.digest }}
{{- printf "@%s" (.image.digest | toString) -}}
{{- else if .image.tag }}
{{- printf ":%s" (.image.tag | toString) -}}
{{- else -}}
{{- printf ":%s" .chart.appVersion -}}
{{- end -}}
{{- end -}}

{{/*
Validate image configuration
{{ include "boilerplate.images.validate" . }}
*/}}
{{- define "boilerplate.images.validate" -}}
{{- if not .image.repository -}}
{{- fail "Image repository is required" -}}
{{- end -}}
{{- if and (not .image.tag) (not .image.digest) -}}
{{- fail "Either image tag or digest must be specified" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image pull policy
{{ include "boilerplate.images.pullPolicy" . }}
*/}}
{{- define "boilerplate.images.pullPolicy" -}}
{{- $globalImagePullPolicy := (.global.imagePullPolicy) | default "" -}}
{{- coalesce .image.pullPolicy $globalImagePullPolicy "IfNotPresent" -}}
{{- end -}}

{{/*
Return the proper image pull secrets
{{ include "boilerplate.images.pullSecrets" . }}
*/}}
{{- define "boilerplate.images.pullSecrets" -}}
{{- $pullSecrets := list -}}
{{- $globalSecrets := (.global.imagePullSecrets) | default list -}}
{{- $imageSecrets := (.image.pullSecrets) | default list -}}
{{- $pullSecrets = concat $pullSecrets $globalSecrets $imageSecrets -}}
{{- if $pullSecrets -}}
imagePullSecrets:
{{- range $pullSecrets }}
- name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}
