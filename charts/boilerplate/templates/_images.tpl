{{/*
Return the proper image name with registry, repository, and version
Usage: {{ include "boilerplate.images.image" ( dict "image" .Values.path.to.the.image "global" .Values.global "chart" .Chart ) }}
*/}}
{{- define "boilerplate.images.image" -}}
{{- $registry := include "boilerplate.images.registry" . -}}
{{- $repository := .image.repository -}}
{{- $version := include "boilerplate.images.version" . -}}
{{- if $registry -}}
{{- printf "%s/%s%s" $registry $repository $version -}}
{{- else -}}
{{- printf "%s%s" $repository $version -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image registry
Usage: {{ include "boilerplate.images.registry" ( dict "image" .image "global" .global ) }}
*/}}
{{- define "boilerplate.images.registry" -}}
{{- $globalRegistry := "" -}}
{{- if and .global (hasKey .global "imageRegistry") .global.imageRegistry -}}
{{- $globalRegistry = .global.imageRegistry -}}
{{- end -}}
{{- coalesce .image.registry $globalRegistry -}}
{{- end -}}

{{/*
Return the proper image version with tag or digest
Usage: {{ include "boilerplate.images.version" ( dict "image" .image "global" .global "chart" .chart ) }}
*/}}
{{- define "boilerplate.images.version" -}}
{{- include "boilerplate.images.validate" . }}
{{- if .image.digest -}}
{{- printf "@%s" (.image.digest | toString) -}}
{{- else if .image.tag -}}
{{- printf ":%s" (.image.tag | toString) -}}
{{- else -}}
{{- printf ":%s" .chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Validate image configuration and fail fast with clear error messages
Usage: {{ include "boilerplate.images.validate" ( dict "image" .image "global" .global "chart" .chart ) }}
*/}}
{{- define "boilerplate.images.validate" -}}
{{- if not .image -}}
{{- fail "Image configuration is required" -}}
{{- end -}}
{{- if not .image.repository -}}
{{- fail "Image repository is required" -}}
{{- end -}}
{{- if and .image.tag .image.digest -}}
{{- fail "Cannot specify both image tag and digest - use one or the other" -}}
{{- end -}}
{{- if and .image.digest (not (regexMatch "^sha256:[a-f0-9]{64}$" .image.digest)) -}}
{{- fail "Image digest must be a valid SHA256 hash (format: sha256:...)" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image pull policy
Usage: {{ include "boilerplate.images.pullPolicy" ( dict "image" .Values.path.to.the.image "global" .Values.global ) }}
*/}}
{{- define "boilerplate.images.pullPolicy" -}}
{{- $globalPullPolicy := "" -}}
{{- if and .global (hasKey .global "imagePullPolicy") .global.imagePullPolicy -}}
{{- $globalPullPolicy = .global.imagePullPolicy -}}
{{- end -}}
{{- $imagePullPolicy := "" -}}
{{- if and .image (hasKey .image "pullPolicy") .image.pullPolicy -}}
{{- $imagePullPolicy = .image.pullPolicy -}}
{{- end -}}
{{- $policy := coalesce $imagePullPolicy $globalPullPolicy "IfNotPresent" -}}
{{- if not (has $policy (list "Always" "Never" "IfNotPresent")) -}}
{{- fail (printf "Invalid imagePullPolicy '%s'. Must be one of: Always, Never, IfNotPresent" $policy) -}}
{{- end -}}
{{- $policy -}}
{{- end -}}

{{/*
Return the proper image pull secrets
Usage: {{ include "boilerplate.images.pullSecrets" ( dict "image" .Values.path.to.the.image "global" .Values.global ) }}
*/}}
{{- define "boilerplate.images.pullSecrets" -}}
{{- $globalSecrets := list -}}
{{- if and .global (hasKey .global "imagePullSecrets") .global.imagePullSecrets -}}
{{- $globalSecrets = .global.imagePullSecrets -}}
{{- end -}}
{{- $imageSecrets := list -}}
{{- if and .image (hasKey .image "pullSecrets") .image.pullSecrets -}}
{{- $imageSecrets = .image.pullSecrets -}}
{{- end -}}
{{- $allSecrets := concat $globalSecrets $imageSecrets -}}
{{- $uniqueSecrets := $allSecrets | uniq -}}
{{- if $uniqueSecrets -}}
imagePullSecrets:
{{- range $uniqueSecrets }}
- name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}
