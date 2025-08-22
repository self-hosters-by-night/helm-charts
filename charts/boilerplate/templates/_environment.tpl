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
Validate environment variable configuration
{{ include "boilerplate.environment.envVars.validate" .Values.env }}
*/}}
{{- define "boilerplate.environment.envVars.validate" -}}
{{- if . }}
{{- if .vars }}
{{- range $key, $value := .vars }}
{{- if not $key }}
{{- fail "Environment variable key in 'vars' cannot be empty" }}
{{- end }}
{{- if not (kindIs "string" $key) }}
{{- fail "Environment variable key in 'vars' must be a string" }}
{{- end }}
{{- end }}
{{- end }}
{{- if .configMapRefs }}
{{- range $key, $config := .configMapRefs }}
{{- if not $key }}
{{- fail "Environment variable key in 'configMapRefs' cannot be empty" }}
{{- end }}
{{- if not (kindIs "string" $key) }}
{{- fail "Environment variable key in 'configMapRefs' must be a string" }}
{{- end }}
{{- if not $config.from }}
{{- fail (printf "configMapRef %s must have 'from' defined" $key) }}
{{- end }}
{{- if not $config.key }}
{{- fail (printf "configMapRef %s must have 'key' defined" $key) }}
{{- end }}
{{- end }}
{{- end }}
{{- if .secretRefs }}
{{- range $key, $config := .secretRefs }}
{{- if not $key }}
{{- fail "Environment variable key in 'secretRefs' cannot be empty" }}
{{- end }}
{{- if not (kindIs "string" $key) }}
{{- fail "Environment variable key in 'secretRefs' must be a string" }}
{{- end }}
{{- if not $config.from }}
{{- fail (printf "secretRef %s must have 'from' defined" $key) }}
{{- end }}
{{- if not $config.key }}
{{- fail (printf "secretRef %s must have 'key' defined" $key) }}
{{- end }}
{{- end }}
{{- end }}
{{- if .configMaps }}
{{- range .configMaps }}
{{- if not .name }}
{{- fail "configMap entry must have 'name' defined" }}
{{- end }}
{{- end }}
{{- end }}
{{- if .secrets }}
{{- range .secrets }}
{{- if not .name }}
{{- fail "secret entry must have 'name' defined" }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
