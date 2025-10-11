{{/*
Return the proper image name with registry, repository, and version
Usage:
{{- include "boilerplate.images.image"
  ( dict
    "root" $
    "image" .Values.path.to.the.image
  ) | nindent 10
}}
*/}}
{{- define "boilerplate.images.image" -}}
{{- include "boilerplate.images.validate" . -}}
{{- $root := .root -}}
{{- $image := .image -}}
{{- $registry := coalesce ($root.Values.global).imageRegistry ($image).registry -}}
{{- $repository := .image.repository -}}
{{- $version := include "boilerplate.images.version" . -}}
{{- if $registry -}}
image: {{ printf "%s/%s%s" $registry $repository $version }}
{{- else -}}
image: {{ printf "%s%s" $repository $version }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image version with tag or digest
Usage:
{{ include "boilerplate.images.version"
  ( dict
    "root" $
    "image" .Values.path.to.the.image
  )
}}
*/}}
{{- define "boilerplate.images.version" -}}
{{- $root := .root -}}
{{- $image := .image -}}
{{- if $image.digest -}}
{{- printf "@%s" ($image.digest | toString) -}}
{{- else if $image.tag -}}
{{- printf ":%s" ($image.tag | toString) -}}
{{- else -}}
{{- printf ":%s" $root.Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Validate image configuration and fail fast with clear error messages
Usage:
{{- include "boilerplate.images.validate"
  (
    "root" $
    "image" .Values.path.to.the.image
  )
-}}
*/}}
{{- define "boilerplate.images.validate" -}}
{{- $root := .root -}}
{{- $image := .image -}}
{{- if not $image -}}
{{- fail "Image configuration is required" -}}
{{- end -}}
{{- if not $image.repository -}}
{{- fail "Image repository is required" -}}
{{- end -}}
{{- if and $image.tag $image.digest -}}
{{- fail "Cannot specify both image tag and digest - use one or the other" -}}
{{- end -}}
{{- if and (not $image.tag) (not $image.digest) (not $root.Chart.AppVersion) -}}
{{- fail "At least one of image.tag, image.digest, or Chart.AppVersion must be specified" -}}
{{- end -}}
{{- if and $image.digest (not (regexMatch "^sha256:[a-f0-9]{64}$" $image.digest)) -}}
{{- fail "Image digest must be a valid SHA256 hash (format: sha256:...)" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image pull policy
Usage:
{{- include "boilerplate.images.pullPolicy"
  ( dict
    "globalPullPolicy" .Values.global.imagePullPolicy
    "localPullPolicy" .Values.path.to.the.imagePullPolicy
  ) | nindent 10
}}
*/}}
{{- define "boilerplate.images.pullPolicy" -}}
{{- $imagePullPolicy := coalesce .globalPullPolicy .localPullPolicy "IfNotPresent" -}}
{{- if not (has $imagePullPolicy (list "Always" "Never" "IfNotPresent")) -}}
{{- fail (printf "Invalid imagePullPolicy '%s'. Must be one of: Always, Never, IfNotPresent" $imagePullPolicy) -}}
{{- end -}}
imagePullPolicy: {{ $imagePullPolicy | quote }}
{{- end -}}

{{/*
Return the proper image pull secrets
Usage:
{{- include "boilerplate.images.pullSecrets"
  ( dict
    "globalImagePullSecrets" .Values.global.imagePullSecrets
    "localImagePullSecrets" .Values.path.to.the.imagePullSecrets
  ) | nindent 6
}}
*/}}
{{- define "boilerplate.images.pullSecrets" -}}
{{- $globalImagePullSecrets := .globalImagePullSecrets | default list -}}
{{- $localImagePullSecrets := .localImagePullSecrets | default list -}}
{{- $imagePullSecrets := concat (deepCopy $globalImagePullSecrets) $localImagePullSecrets | uniq -}}
{{- $normalizedSecrets := list -}}
{{- range $imagePullSecrets -}}
  {{- if kindIs "string" . -}}
    {{- /* If it's a string, convert to map with "name" key */ -}}
    {{- $normalizedSecrets = append $normalizedSecrets (dict "name" .) -}}
  {{- else if kindIs "map" . -}}
    {{- /* If it's already a map, use it as-is */ -}}
    {{- $normalizedSecrets = append $normalizedSecrets . -}}
  {{- end -}}
{{- end -}}
{{- if $normalizedSecrets -}}
imagePullSecrets:
  {{- range $secret := $normalizedSecrets }}
  - {{ $secret | toYaml | trim }}
  {{- end }}
{{- else -}}
imagePullSecrets: []
{{- end -}}
{{- end -}}
