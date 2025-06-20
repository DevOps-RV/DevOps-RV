{{/*
Generate a name that can be used as a label or resource name.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate a fully qualified app name.
*/}}
{{- define "chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := include "chart.name" . }}
{{- if contains $name .Release.Name }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate common labels.
*/}}
{{- define "chart.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Generate selector labels.
*/}}
{{- define "chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Generate environment-specific labels.
*/}}
{{- define "chart.envLabels" -}}
tier: {{ .Values.tier | default "backend" }}
environment: {{ .Values.environment | default "production" }}
{{- end }}

{{/*
Generate a namespace for resources.
*/}}
{{- define "chart.namespace" -}}
{{- default .Release.Namespace "default" }}
{{- end }}

{{/*
Generate common annotations.
*/}}
{{- define "chart.annotations" -}}
annotation-key-1: annotation-value-1
annotation-key-2: annotation-value-2
{{- end }}

{{/*
Determine the appropriate apiVersion for Deployment based on cluster capabilities.
*/}}
{{- define "chart.apiVersion.deployment" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1" -}}
apps/v1
{{- else -}}
extensions/v1beta1
{{- end }}
{{- end }}

{{/*
Determine the appropriate apiVersion for Ingress based on cluster capabilities.
*/}}
{{- define "chart.apiVersion.ingress" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1" -}}
networking.k8s.io/v1
{{- else if .Capabilities.APIVersions.Has "extensions/v1beta1" -}}
extensions/v1beta1
{{- else -}}
networking.k8s.io/v1beta1
{{- end }}
{{- end }}

{{/*
Determine the appropriate apiVersion for Service based on cluster capabilities.
*/}}
{{- define "chart.apiVersion.service" -}}
v1
{{- end }}

{{/*
Determine the appropriate apiVersion for HorizontalPodAutoscaler (HPA) based on cluster capabilities.
*/}}
{{- define "chart.apiVersion.hpa" -}}
{{- if .Capabilities.APIVersions.Has "autoscaling/v2" -}}
autoscaling/v2
{{- else if .Capabilities.APIVersions.Has "autoscaling/v2beta2" -}}
autoscaling/v2beta2
{{- else if .Capabilities.APIVersions.Has "autoscaling/v2beta1" -}}
autoscaling/v2beta1
{{- else -}}
autoscaling/v1
{{- end }}
{{- end }}