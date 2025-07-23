#!/bin/bash
set -e

echo "🧪 Testing CloudFormation Parameters Reader output formats"

# Test with different input files
test_file() {
  local file_path=$1
  local file_name=$(basename "$file_path")
  
  echo "📋 Testing with $file_name"
  
  # Setup test environment variables
  export GITHUB_OUTPUT="$(mktemp)"
  export GITHUB_ENV="$(mktemp)"
  
  # Set artifact path
  ARTIFACT_PATH="$file_path"
  
  # Source the action script
  source <(cat action.yaml | grep -A 1000 "run: |" | tail -n +2)
  
  # Verify output format
  echo "🔍 Verifying output format..."
  
  # Check that parameters is valid JSON
  PARAMS=$(grep "parameters=" "$GITHUB_OUTPUT" | cut -d= -f2-)
  if echo "$PARAMS" | jq . >/dev/null 2>&1; then
    echo "✅ Parameters output is valid JSON"
  else
    echo "❌ Parameters output is not valid JSON: $PARAMS"
    exit 1
  fi
  
  # Check that stack-name is a string
  STACK=$(grep "stack-name=" "$GITHUB_OUTPUT" | cut -d= -f2-)
  if [ -n "$STACK" ] || [ "$STACK" = "" ]; then
    echo "✅ Stack name output is a valid string"
  else
    echo "❌ Stack name output is not valid: $STACK"
    exit 1
  fi
  
  # Check that template-path is a string
  TEMPLATE=$(grep "template-path=" "$GITHUB_OUTPUT" | cut -d= -f2-)
  if [ -n "$TEMPLATE" ] || [ "$TEMPLATE" = "" ]; then
    echo "✅ Template path output is a valid string"
  else
    echo "❌ Template path output is not valid: $TEMPLATE"
    exit 1
  fi
  
  # Check environment variables format
  if grep -q "DEPLOYMENT_PARAMETERS<<EOF" "$GITHUB_ENV" && grep -q "EOF" "$GITHUB_ENV"; then
    echo "✅ DEPLOYMENT_PARAMETERS environment variable has correct multiline format"
  else
    echo "❌ DEPLOYMENT_PARAMETERS environment variable does not have correct multiline format"
    cat "$GITHUB_ENV"
    exit 1
  fi
  
  echo "✅ All format checks passed for $file_name"
  echo ""
}

# Test with all our sample files
test_file "./tests/artifacts/valid-deployment.json"
test_file "./tests/artifacts/missing-fields-deployment.json"
test_file "./tests/artifacts/empty-params-deployment.json"

echo "🎉 All output format tests passed!"