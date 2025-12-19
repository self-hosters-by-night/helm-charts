{{/*
Render environment variables (env section)
Usage: {{ include "boilerplate.environment.env" ( dict "root" . "env" .Values.env ) }}
*/}}
{{- define "boilerplate.environment.env" -}}
{{- $root := .root -}}
{{- $env := .env -}}

{{- include "boilerplate.environment.env.validate" .env }}
{{- if or $env.vars $env.fromConfigMap $env.fromSecret }}
env:
  {{- range $key, $value := $env.vars }}
  - name: {{  tpl ($key | toString) $root | quote }}
    value: {{ tpl ($value | toString) $root | quote }}
  {{- end }}
  {{- range $key, $config := $env.fromConfigMap }}
  - name: {{  tpl ($key | toString) $root | quote }}
    valueFrom:
      configMapKeyRef:
        name: {{ tpl ($config.from | toString) $root | quote }}
        key: {{ tpl ($config.key | toString) $root | quote }}
        {{- if $config.optional }}
        optional: {{ $config.optional }}
        {{- end }}
  {{- end }}
  {{- range $key, $config := $env.fromSecret }}
  - name: {{ tpl ($key | toString) $root | quote }}
    valueFrom:
      secretKeyRef:
        name: {{ tpl ($config.from | toString) $root | quote }}
        key: {{ tpl ($config.key | toString) $root | quote }}
        {{- if $config.optional }}
        optional: {{ $config.optional }}
        {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Render environment variables from external sources (envFrom section)
Usage: {{ include "boilerplate.environment.envFrom" ( dict "root" . "envFrom" .Values.envFrom ) }}
*/}}
{{- define "boilerplate.environment.envFrom" -}}
{{- $root := .root -}}
{{- $envFrom := .envFrom -}}

{{- if or $envFrom.configMaps $envFrom.secrets }}
envFrom:
  {{- range $envFrom.configMaps }}
  - configMapRef:
      name: {{ tpl (.name | toString) $root | quote }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
  {{- end }}
  {{- range $envFrom.secrets }}
  - secretRef:
      name: {{ tpl (.name | toString) $root | quote }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Validate environment variable configuration for env section
{{ include "boilerplate.environment.env.validate" .Values.env }}
*/}}
{{- define "boilerplate.environment.env.validate" -}}
{{- if . -}}
  {{/* Validate that input is a map */}}
  {{- if not (kindIs "map" .) }}
    {{- fail "Environment configuration must be a map/object" }}
  {{- end -}}

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
      {{- end -}}

      {{/* Validate value is not nil and convert to string if needed */}}
      {{- if eq $value nil }}
        {{- fail (printf "Environment variable '%s' has nil value. Use empty string if needed" $key) }}
      {{- end }}
    {{- end }}
  {{- end -}}

  {{/* Validate fromConfigMap section */}}
  {{- if .fromConfigMap }}
    {{- if not (kindIs "map" .fromConfigMap) }}
      {{- fail "'fromConfigMap' must be a map of environment variable definitions" }}
    {{- end }}
    {{- range $key, $config := .fromConfigMap }}
      {{- if not $key }}
        {{- fail "Environment variable key in 'fromConfigMap' cannot be empty" }}
      {{- end }}
      {{- if not (kindIs "string" $key) }}
        {{- fail "Environment variable key in 'fromConfigMap' must be a string" }}
      {{- end }}
      {{- if not (kindIs "map" $config) }}
        {{- fail (printf "fromConfigMap '%s' must be a map with 'from' and 'key' fields" $key) }}
      {{- end }}
      {{- if not $config.from }}
        {{- fail (printf "fromConfigMap '%s' must have 'from' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.from) }}
        {{- fail (printf "fromConfigMap '%s' 'from' field must be a string" $key) }}
      {{- end }}
      {{- if not $config.key }}
        {{- fail (printf "fromConfigMap '%s' must have 'key' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.key) }}
        {{- fail (printf "fromConfigMap '%s' 'key' field must be a string" $key) }}
      {{- end -}}

      {{/* Validate optional field if present */}}
      {{- if hasKey $config "optional" }}
        {{- if not (kindIs "bool" $config.optional) }}
          {{- fail (printf "fromConfigMap '%s' 'optional' field must be a boolean" $key) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end -}}

  {{/* Validate fromSecret section */}}
  {{- if .fromSecret }}
    {{- if not (kindIs "map" .fromSecret) }}
      {{- fail "'fromSecret' must be a map of environment variable definitions" }}
    {{- end }}
    {{- range $key, $config := .fromSecret }}
      {{- if not $key }}
        {{- fail "Environment variable key in 'fromSecret' cannot be empty" }}
      {{- end }}
      {{- if not (kindIs "string" $key) }}
        {{- fail "Environment variable key in 'fromSecret' must be a string" }}
      {{- end }}
      {{- if not (kindIs "map" $config) }}
        {{- fail (printf "fromSecret '%s' must be a map with 'from' and 'key' fields" $key) }}
      {{- end }}
      {{- if not $config.from }}
        {{- fail (printf "fromSecret '%s' must have 'from' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.from) }}
        {{- fail (printf "fromSecret '%s' 'from' field must be a string" $key) }}
      {{- end }}
      {{- if not $config.key }}
        {{- fail (printf "fromSecret '%s' must have 'key' field defined" $key) }}
      {{- end }}
      {{- if not (kindIs "string" $config.key) }}
        {{- fail (printf "fromSecret '%s' 'key' field must be a string" $key) }}
      {{- end -}}

      {{/* Validate optional field if present */}}
      {{- if hasKey $config "optional" }}
        {{- if not (kindIs "bool" $config.optional) }}
          {{- fail (printf "fromSecret '%s' 'optional' field must be a boolean" $key) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end -}}

  {{/* Check for duplicate environment variable names across different sources */}}
  {{- $allEnvVars := dict }}
  {{- if .vars }}
    {{- range $key, $value := .vars }}
      {{- $_ := set $allEnvVars $key "vars" }}
    {{- end }}
  {{- end }}
  {{- if .fromConfigMap }}
    {{- range $key, $config := .fromConfigMap }}
      {{- if hasKey $allEnvVars $key }}
        {{- fail (printf "Duplicate environment variable '%s' found in both '%s' and 'fromConfigMap'" $key (index $allEnvVars $key)) }}
      {{- end }}
      {{- $_ := set $allEnvVars $key "fromConfigMap" }}
    {{- end }}
  {{- end }}
  {{- if .fromSecret }}
    {{- range $key, $config := .fromSecret }}
      {{- if hasKey $allEnvVars $key }}
        {{- fail (printf "Duplicate environment variable '%s' found in both '%s' and 'fromSecret'" $key (index $allEnvVars $key)) }}
      {{- end }}
      {{- $_ := set $allEnvVars $key "fromSecret" }}
    {{- end }}
  {{- end -}}

  {{/* Validate no unknown fields */}}
  {{- $validFields := list "vars" "fromConfigMap" "fromSecret" }}
  {{- range $field, $value := . }}
    {{- if not (has $field $validFields) }}
      {{- fail (printf "Unknown field '%s' in environment configuration. Valid fields are: %s" $field (join ", " $validFields)) }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Validate envFrom configuration
{{ include "boilerplate.environment.envFrom.validate" .Values.envFrom }}
*/}}
{{- define "boilerplate.environment.envFrom.validate" -}}
{{- if . }}
  {{/* Validate that input is a map */}}
  {{- if not (kindIs "map" .) }}
    {{- fail "EnvFrom configuration must be a map/object" }}
  {{- end -}}

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
      {{- end -}}

      {{/* Validate optional field if present */}}
      {{- if hasKey $configMap "optional" }}
        {{- if not (kindIs "bool" $configMap.optional) }}
          {{- fail (printf "configMap entry at index %d 'optional' field must be a boolean" $index) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end -}}

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
      {{- end -}}

      {{/* Validate optional field if present */}}
      {{- if hasKey $secret "optional" }}
        {{- if not (kindIs "bool" $secret.optional) }}
          {{- fail (printf "secret entry at index %d 'optional' field must be a boolean" $index) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end -}}

  {{/* Validate no unknown fields */}}
  {{- $validFields := list "configMaps" "secrets" }}
  {{- range $field, $value := . }}
    {{- if not (has $field $validFields) }}
      {{- fail (printf "Unknown field '%s' in envFrom configuration. Valid fields are: %s" $field (join ", " $validFields)) }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end -}}
