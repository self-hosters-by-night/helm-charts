{{- define "postgres.majorVersion" -}}
{{- $appVersion := .Chart.AppVersion | toString -}}
{{- $majorVersion := regexFind "^[0-9]+" $appVersion -}}
{{- $majorVersion -}}
{{- end -}}
