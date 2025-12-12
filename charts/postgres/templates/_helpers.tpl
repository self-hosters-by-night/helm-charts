{{- define "postgres.majorVersion" -}}
{{- $appVersion := .Chart.AppVersion | toString -}}
{{- $majorVersion := regexFind "^[0-9]+" $appVersion -}}
{{- $majorVersion -}}
{{- end -}}

{{/*
Render env values with templated resource names.
*/}}
{{- define "postgres.renderEnv" -}}
{{- $root := .root -}}
{{- $env := default (dict) .env -}}
{{- $out := dict -}}

{{- if $env.vars }}
  {{- $vars := dict }}
  {{- range $key, $value := $env.vars }}
    {{- $rendered := $value }}
    {{- if kindIs "string" $value }}
      {{- $rendered = tpl ($value | toString) $root }}
    {{- end }}
    {{- $_ := set $vars $key $rendered }}
  {{- end }}
  {{- $_ := set $out "vars" $vars }}
{{- end }}

{{- if $env.fromConfigMap }}
  {{- $configMaps := dict }}
  {{- range $key, $config := $env.fromConfigMap }}
    {{- $name := $config.from }}
    {{- if $config.from }}
      {{- $name = tpl ($config.from | toString) $root }}
    {{- end }}
    {{- $entry := dict "from" $name "key" $config.key }}
    {{- if hasKey $config "optional" }}
      {{- $_ := set $entry "optional" $config.optional }}
    {{- end }}
    {{- $_ := set $configMaps $key $entry }}
  {{- end }}
  {{- $_ := set $out "fromConfigMap" $configMaps }}
{{- end }}

{{- if $env.fromSecret }}
  {{- $secrets := dict }}
  {{- range $key, $config := $env.fromSecret }}
    {{- $name := $config.from }}
    {{- if $config.from }}
      {{- $name = tpl ($config.from | toString) $root }}
    {{- end }}
    {{- $entry := dict "from" $name "key" $config.key }}
    {{- if hasKey $config "optional" }}
      {{- $_ := set $entry "optional" $config.optional }}
    {{- end }}
    {{- $_ := set $secrets $key $entry }}
  {{- end }}
  {{- $_ := set $out "fromSecret" $secrets }}
{{- end }}

{{- toYaml $out }}
{{- end -}}

{{/*
Render envFrom values with templated resource names.
*/}}
{{- define "postgres.renderEnvFrom" -}}
{{- $root := .root -}}
{{- $envFrom := default (dict) .envFrom -}}
{{- $out := dict -}}

{{- if $envFrom.configMaps }}
  {{- $configMaps := list }}
  {{- range $envFrom.configMaps }}
    {{- $name := .name }}
    {{- if .name }}
      {{- $name = tpl (.name | toString) $root }}
    {{- end }}
    {{- $entry := dict "name" $name }}
    {{- if hasKey . "optional" }}
      {{- $_ := set $entry "optional" .optional }}
    {{- end }}
    {{- $configMaps = append $configMaps $entry }}
  {{- end }}
  {{- $_ := set $out "configMaps" $configMaps }}
{{- end }}

{{- if $envFrom.secrets }}
  {{- $secrets := list }}
  {{- range $envFrom.secrets }}
    {{- $name := .name }}
    {{- if .name }}
      {{- $name = tpl (.name | toString) $root }}
    {{- end }}
    {{- $entry := dict "name" $name }}
    {{- if hasKey . "optional" }}
      {{- $_ := set $entry "optional" .optional }}
    {{- end }}
    {{- $secrets = append $secrets $entry }}
  {{- end }}
  {{- $_ := set $out "secrets" $secrets }}
{{- end }}

{{- toYaml $out }}
{{- end -}}
