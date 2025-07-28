#!/bin/bash
set -e

echo "🧪 Testing CloudFormation Parameters Reader with valid input"

# Setup test environment variables
export GITHUB_OUTPUT="$(mktemp)"
export GITHUB_ENV="$(mktemp)"

# Run the action script with valid deployment file
echo "📋 Running with valid-deployment.json"
ARTIFACT_PATH="./tests/artifacts/valid-deployment.json"

# Source the action script (simulating GitHub Actions)
source <(cat action.yaml | grep -A 1000 "run: |" | tail -n +2)

# Verify outputs were set correctly
echo "🔍 Verifying outputs..."
if grep -q "parameters={\"EnvironmentName\":\"dev\",\"VpcCidr\":\"10.0.0.0/16\",\"PublicSubnet1Cidr\":\"10.0.1.0/24\",\"PublicSubnet2Cidr\":\"10.0.2.0/24\",\"PrivateSubnet1Cidr\":\"10.0.3.0/24\",\"PrivateSubnet2Cidr\":\"10.0.4.0/24\"}" "$GITHUB_OUTPUT"; then
  echo "✅ Parameters output correctly set"
else
  echo "❌ Parameters output not set correctly"
  cat "$GITHUB_OUTPUT"
  exit 1
fi

if grep -q "stack-name=network-infrastructure" "$GITHUB_OUTPUT"; then
  echo "✅ Stack name output correctly set"
else
  echo "❌ Stack name output not set correctly"
  cat "$GITHUB_OUTPUT"
  exit 1
fi

if grep -q "template-path=./templates/network.yaml" "$GITHUB_OUTPUT"; then
  echo "✅ Template path output correctly set"
else
  echo "❌ Template path output not set correctly"
  cat "$GITHUB_OUTPUT"
  exit 1
fi

# Verify environment variables were set correctly
echo "🔍 Verifying environment variables..."
if grep -q "DEPLOYMENT_PARAMETERS<<EOF" "$GITHUB_ENV" && 
   grep -q "{\"EnvironmentName\":\"dev\",\"VpcCidr\":\"10.0.0.0/16\",\"PublicSubnet1Cidr\":\"10.0.1.0/24\",\"PublicSubnet2Cidr\":\"10.0.2.0/24\",\"PrivateSubnet1Cidr\":\"10.0.3.0/24\",\"PrivateSubnet2Cidr\":\"10.0.4.0/24\"}" "$GITHUB_ENV" &&
   grep -q "EOF" "$GITHUB_ENV"; then
  echo "✅ DEPLOYMENT_PARAMETERS environment variable correctly set"
else
  echo "❌ DEPLOYMENT_PARAMETERS environment variable not set correctly"
  cat "$GITHUB_ENV"
  exit 1
fi

if grep -q "DEPLOYMENT_STACK_NAME=network-infrastructure" "$GITHUB_ENV"; then
  echo "✅ DEPLOYMENT_STACK_NAME environment variable correctly set"
else
  echo "❌ DEPLOYMENT_STACK_NAME environment variable not set correctly"
  cat "$GITHUB_ENV"
  exit 1
fi

if grep -q "DEPLOYMENT_TEMPLATE_PATH=./templates/network.yaml" "$GITHUB_ENV"; then
  echo "✅ DEPLOYMENT_TEMPLATE_PATH environment variable correctly set"
else
  echo "❌ DEPLOYMENT_TEMPLATE_PATH environment variable not set correctly"
  cat "$GITHUB_ENV"
  exit 1
fi

echo "🎉 All tests passed for valid input!"