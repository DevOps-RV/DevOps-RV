#!/bin/bash

SERVICE_NAME=$1
TEMPLATE_PATH="$(cd "$(dirname "$0")"; pwd)/eks-service-chart-template"

if [ -z "$SERVICE_NAME" ]; then
  echo "Usage: ./create-chart.sh <service-name>"
  exit 1
fi

if [ ! -d "$TEMPLATE_PATH" ]; then
  echo "Error: Starter template not found at $TEMPLATE_PATH"
  exit 1
fi

echo "Creating Helm chart for '$SERVICE_NAME' using starter template from '$TEMPLATE_PATH'..."
helm create "$SERVICE_NAME" --starter "$TEMPLATE_PATH"