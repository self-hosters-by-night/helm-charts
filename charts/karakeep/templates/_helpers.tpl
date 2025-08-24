{{/*
Karakeep helper templates that wrap boilerplate functions
*/}}

{{/*
Return environment variables
*/}}
{{- define "karakeep.environment.env" -}}
{{- include "boilerplate.environment.env" (dict "env" .Values.env "global" .Values.global) -}}
{{- end -}}

{{/*
Return environment variables from configmaps/secrets
*/}}
{{- define "karakeep.environment.envFrom" -}}
{{- $configMap := include "boilerplate.names.fullname" . -}}
{{- $envFrom := .Values.envFrom | default dict -}}
{{- $configMaps := $envFrom.configMaps | default list -}}
{{- $envFromConfigMaps := append $configMaps (dict "name" $configMap) -}}
{{- $_ := set $envFrom "configMaps" $envFromConfigMaps -}}
{{- include "boilerplate.environment.envFrom" (dict "envFrom" $envFrom "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name
*/}}
{{- define "karakeep.image" -}}
{{- include "boilerplate.images.image" (dict "image" .Values.image "global" .Values.global "chart" .Chart) }}
{{- end -}}

{{/*
Return the proper image pull policy
*/}}
{{- define "karakeep.imagePullPolicy" -}}
{{- include "boilerplate.images.pullPolicy" (dict "image" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image pull secrets
*/}}
{{- define "karakeep.imagePullSecrets" -}}
{{- include "boilerplate.images.pullSecrets" (dict "image" .Values.image "global" .Values.global) }}
{{- end -}}
