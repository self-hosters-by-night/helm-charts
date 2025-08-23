{{/*
Expand the name of the chart.
*/}}
{{- define "boilerplate.names.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if not (regexMatch "^[a-zA-Z0-9]([a-zA-Z0-9\\-]*[a-zA-Z0-9])?$" $name) -}}
{{- fail (printf "Invalid name '%s'. Must start and end with alphanumeric characters and contain only alphanumeric characters and hyphens" $name) -}}
{{- end -}}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "boilerplate.names.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- if not (regexMatch "^[a-zA-Z0-9]([a-zA-Z0-9\\-]*[a-zA-Z0-9])?$" $fullname) -}}
{{- fail (printf "Invalid fullname '%s'. Must start and end with alphanumeric characters and contain only alphanumeric characters and hyphens" $fullname) -}}
{{- end -}}
{{- $fullname | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "boilerplate.names.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "boilerplate.names.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "boilerplate.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
