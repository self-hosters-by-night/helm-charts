{{/*
Render environment variables with support for vars, configMapRefs, secretRefs, configMaps, and secrets
Usage: {{ include "boilerplate.environment.envVars" ( dict "env" .Values.path.to.env "global" .Values.global ) }}
*/}}
{{- define "boilerplate.environment.envVars" -}}
{{ include "boilerplate.environment.envVars.validate" .env }}
{{- if .env -}}
{{- $hasEnvVars := or .env.vars .env.configMapRefs .env.secretRefs -}}
{{- $hasEnvFrom := or .env.configMaps .env.secrets -}}
{{- if $hasEnvFrom }}
envFrom:
{{- range .env.configMaps }}
- configMapRef:
    name: {{ .name | quote }}
    {{- if .optional }}
    optional: {{ .optional }}
    {{- end }}
{{- end }}
{{- range .env.secrets }}
- secretRef:
    name: {{ .name | quote }}
    {{- if .optional }}
    optional: {{ .optional }}
    {{- end }}
{{- end }}
{{- end }}
{{- if $hasEnvVars }}
env:
{{- range $key, $value := .env.vars }}
- name: {{ $key | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- range $key, $config := .env.configMapRefs }}
- name: {{ $key | quote }}
  valueFrom:
    configMapKeyRef:
      name: {{ $config.from | quote }}
      key: {{ $config.key | quote }}
      {{- if $config.optional }}
      optional: {{ $config.optional }}
      {{- end }}
{{- end }}
{{- range $key, $config := .env.secretRefs }}
- name: {{ $key | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ $config.from | quote }}
      key: {{ $config.key | quote }}
      {{- if $config.optional }}
      optional: {{ $config.optional }}
      {{- end }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Validate environment variable configuration with comprehensive checks
{{ include "boilerplate.environment.envVars.validate" .Values.env }}
*/}}
{{- define "boilerplate.environment.envVars.validate" -}}
{{- if . }}
  {{/* Validate that input is a map */}}
  {{- if not (kindIs "map" .) }}
    {{- fail "Environment configuration must be a map/object" }}
  {{- end }}

  {{/* Validate vars section */}}
  {{- if .vars }}
    {{- if not (kindIs "map" .vars) }}
      {{- fail "'vars' must be a map of key-value pairs" }}
    {{- end }}
    {{- range $key, $value := .vars }}
      {{- if not $key }}
        {{- fail "Environment variable key in 'vars' cannot be empty" }}
      {{- end }}
      {{- if not (kindIs "string" $key) }}
        {{- fail "Environment variable key in 'vars' must be a string" }}
      {{- end }}
      {{/* Validate Kubernetes environment variable naming rules */}}
      {{- if not (regexMatch "^[A-Za-z_][A-Za-z0-9_]*$" $key) }}
        {{- fail (printf "Environment variable key '%s' is invalid. Must start with letter or underscore and contain only alphanumeric characters and underscores" $key) }}
      {{- end }}
      {{/* Check for reserved environment variable names */}}
      {{- $reservedVars := list "HOSTNAME" "PATH" "HOME" "TERM" }}
      {{- if has $key $reservedVars }}
        {{- fail (printf "Environment variable key '%s' is reserved and should not be overridden" $key) }}
      {{- end }}
      {{/* Validate value is not nil and convert to string if needed */}}
      {{- if eq $value nil }}
        {{- fail (printf "Environment variable '%s' has nil value. Use empty string if needed" $key) }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{/* Validate configMapRefs section */}}
  {{- if .configMapRefs }}
    {{- if not (kindIs "map" .configMapRefs) }}
      {{- fail "'configMapRefs' must be a map of environment variable definitions" }}
    {{- end }}
    {{- range $key, $config := .configMapRefs }}
      {{- if not $key }}
        {{- fail "Environment variable key in 'configMapRefs' cannot be empty" }}
      {{- end }}
      {{- if not (kindIs "string" $key) }}
        {{- fail "Environment variable key in 'configMapRefs' must be a string" }}
      {{- end }}
      {{- if not (regexMatch "^[A-Za-z_][A-Za-z0-9_]*$" $key) }}
        {{- fail (printf "Environment variable key '%s' in configMapRefs is invalid. Must start with letter or underscore and contain only alphanumeric characters and underscores" $key) }}
      {{- end }}
      {{- if not (kindIs "map" $config) }}
        {{- fail (printf "configMapRef '%s' must be a map with 'from' and 'key' fields" $key) }}
      {{- end }}
      {{- if not $config.from }}
        {{- fail (printf "configMapRef '%s' must have 'from' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.from) }}
        {{- fail (printf "configMapRef '%s' 'from' field must be a string" $key) }}
      {{- end }}
      {{- if not $config.key }}
        {{- fail (printf "configMapRef '%s' must have 'key' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.key) }}
        {{- fail (printf "configMapRef '%s' 'key' field must be a string" $key) }}
      {{- end }}
      {{/* Validate Kubernetes resource name for configMap */}}
      {{- if not (regexMatch "^[a-z0-9]([a-z0-9\\-]*[a-z0-9])?$" $config.from) }}
        {{- fail (printf "configMapRef '%s' 'from' field '%s' is not a valid Kubernetes resource name" $key $config.from) }}
      {{- end }}
      {{/* Validate optional field if present */}}
      {{- if hasKey $config "optional" }}
        {{- if not (kindIs "bool" $config.optional) }}
          {{- fail (printf "configMapRef '%s' 'optional' field must be a boolean" $key) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{/* Validate secretRefs section */}}
  {{- if .secretRefs }}
    {{- if not (kindIs "map" .secretRefs) }}
      {{- fail "'secretRefs' must be a map of environment variable definitions" }}
    {{- end }}
    {{- range $key, $config := .secretRefs }}
      {{- if not $key }}
        {{- fail "Environment variable key in 'secretRefs' cannot be empty" }}
      {{- end }}
      {{- if not (kindIs "string" $key) }}
        {{- fail "Environment variable key in 'secretRefs' must be a string" }}
      {{- end }}
      {{- if not (regexMatch "^[A-Za-z_][A-Za-z0-9_]*$" $key) }}
        {{- fail (printf "Environment variable key '%s' in secretRefs is invalid. Must start with letter or underscore and contain only alphanumeric characters and underscores" $key) }}
      {{- end }}
      {{- if not (kindIs "map" $config) }}
        {{- fail (printf "secretRef '%s' must be a map with 'from' and 'key' fields" $key) }}
      {{- end }}
      {{- if not $config.from }}
        {{- fail (printf "secretRef '%s' must have 'from' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.from) }}
        {{- fail (printf "secretRef '%s' 'from' field must be a string" $key) }}
      {{- end }}
      {{- if not $config.key }}
        {{- fail (printf "secretRef '%s' must have 'key' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.key) }}
        {{- fail (printf "secretRef '%s' 'key' field must be a string" $key) }}
      {{- end }}
      {{/* Validate Kubernetes resource name for secret */}}
      {{- if not (regexMatch "^[a-z0-9]([a-z0-9\\-]*[a-z0-9])?$" $config.from) }}
        {{- fail (printf "secretRef '%s' 'from' field '%s' is not a valid Kubernetes resource name" $key $config.from) }}
      {{- end }}
      {{/* Validate optional field if present */}}
      {{- if hasKey $config "optional" }}
        {{- if not (kindIs "bool" $config.optional) }}
          {{- fail (printf "secretRef '%s' 'optional' field must be a boolean" $key) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{/* Validate configMaps section */}}
  {{- if .configMaps }}
    {{- if not (kindIs "slice" .configMaps) }}
      {{- fail "'configMaps' must be a list of configMap references" }}
    {{- end }}
    {{- range $index, $configMap := .configMaps }}
      {{- if not (kindIs "map" $configMap) }}
        {{- fail (printf "configMap entry at index %d must be a map" $index) }}
      {{- end }}
      {{- if not $configMap.name }}
        {{- fail (printf "configMap entry at index %d must have 'name' field defined" $index) }}
      {{- end }}
      {{- if not (kindIs "string" $configMap.name) }}
        {{- fail (printf "configMap entry at index %d 'name' field must be a string" $index) }}
      {{- end }}
      {{/* Validate Kubernetes resource name */}}
      {{- if not (regexMatch "^[a-z0-9]([a-z0-9\\-]*[a-z0-9])?$" $configMap.name) }}
        {{- fail (printf "configMap entry at index %d 'name' field '%s' is not a valid Kubernetes resource name" $index $configMap.name) }}
      {{- end }}
      {{/* Validate optional field if present */}}
      {{- if hasKey $configMap "optional" }}
        {{- if not (kindIs "bool" $configMap.optional) }}
          {{- fail (printf "configMap entry at index %d 'optional' field must be a boolean" $index) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{/* Validate secrets section */}}
  {{- if .secrets }}
    {{- if not (kindIs "slice" .secrets) }}
      {{- fail "'secrets' must be a list of secret references" }}
    {{- end }}
    {{- range $index, $secret := .secrets }}
      {{- if not (kindIs "map" $secret) }}
        {{- fail (printf "secret entry at index %d must be a map" $index) }}
      {{- end }}
      {{- if not $secret.name }}
        {{- fail (printf "secret entry at index %d must have 'name' field defined" $index) }}
      {{- end }}
      {{- if not (kindIs "string" $secret.name) }}
        {{- fail (printf "secret entry at index %d 'name' field must be a string" $index) }}
      {{- end }}
      {{/* Validate Kubernetes resource name */}}
      {{- if not (regexMatch "^[a-z0-9]([a-z0-9\\-]*[a-z0-9])?$" $secret.name) }}
        {{- fail (printf "secret entry at index %d 'name' field '%s' is not a valid Kubernetes resource name" $index $secret.name) }}
      {{- end }}
      {{/* Validate optional field if present */}}
      {{- if hasKey $secret "optional" }}
        {{- if not (kindIs "bool" $secret.optional) }}
          {{- fail (printf "secret entry at index %d 'optional' field must be a boolean" $index) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{/* Check for duplicate environment variable names across different sources */}}
  {{- $allEnvVars := dict }}
  {{- if .vars }}
    {{- range $key, $value := .vars }}
      {{- $_ := set $allEnvVars $key "vars" }}
    {{- end }}
  {{- end }}
  {{- if .configMapRefs }}
    {{- range $key, $config := .configMapRefs }}
      {{- if hasKey $allEnvVars $key }}
        {{- fail (printf "Duplicate environment variable '%s' found in both '%s' and 'configMapRefs'" $key (index $allEnvVars $key)) }}
      {{- end }}
      {{- $_ := set $allEnvVars $key "configMapRefs" }}
    {{- end }}
  {{- end }}
  {{- if .secretRefs }}
    {{- range $key, $config := .secretRefs }}
      {{- if hasKey $allEnvVars $key }}
        {{- fail (printf "Duplicate environment variable '%s' found in both '%s' and 'secretRefs'" $key (index $allEnvVars $key)) }}
      {{- end }}
      {{- $_ := set $allEnvVars $key "secretRefs" }}
    {{- end }}
  {{- end }}

  {{/* Validate no unknown fields */}}
  {{- $validFields := list "vars" "configMapRefs" "secretRefs" "configMaps" "secrets" }}
  {{- range $field, $value := . }}
    {{- if not (has $field $validFields) }}
      {{- fail (printf "Unknown field '%s' in environment configuration. Valid fields are: %s" $field (join ", " $validFields)) }}
    {{- end }}
  {{- end }}

{{- end }}
{{- end -}}
