{{/*
Expand the name of the chart.
*/}}
{{- define "fullname" -}}
{{- if .Values.global.fullnameOverride }}
  {{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
  {{- $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
amnic.io/app: {{ include "fullname" . }}
amnic.io/chart: {{ .Chart.Name }}-v{{ .Chart.Version }}
amnic.io/type: workload
{{- range $key, $value := $.Values.global.labels }}
{{ $key }}: {{ $value }}
{{- end }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "common.annotations" -}}
{{- $description := "" -}}
{{- if .Values.global.description }}
{{- $description = .Values.global.description }}
{{- else -}}
{{- $description = include "fullname" . | replace "-" " " | trim | lower | title }}
{{- end -}}
description: "{{ $description }}"
{{- if .Values.global.annotations }}
{{- range $key, $value := .Values.global.annotations }}
{{ $key }}: {{ $value }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Common label selector
*/}}
{{- define "common.selector" -}}
amnic.io/app: {{ include "fullname" . }}
{{- end }}

{{/*
Service ports
*/}}
{{- define "common.servicePorts" -}}
{{- $ports := .Values.service.ports | default dict -}}
{{- if hasKey $ports "http-default" -}}
- name: "http-default"
  port: {{ (index $ports "http-default").port | default 80 }}
  targetPort: {{ (index $ports "http-default").targetPort | default .Values.port }}
  {{- if (index $ports "http-default").protocol }}
  protocol: {{ (index $ports "http-default").protocol }}
  {{- end }}
{{- else -}}
- name: "http-default"
  port: 80
  targetPort: {{ .Values.port }}
{{- end }}
{{- range $key, $value := $ports }}
  {{- if ne $key "http-default" }}
- name: {{ $key | quote }}
  port: {{ $value.port }}
  targetPort: {{ $value.targetPort }}
  {{- if $value.protocol }}
  protocol: {{ $value.protocol }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}
