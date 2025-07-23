#!/bin/bash

echo "🧪 Testing CloudFormation Parameters Reader with missing file"

# Setup test environment variables
export GITHUB_OUTPUT="$(mktemp)"
export GITHUB_ENV="$(mktemp)"

# Run the action script with non-existent file
echo "📋 Running with non-existent file"
ARTIFACT_PATH="./tests/artifacts/non-existent-file.json"

# Source the action script but capture the exit code
(source <(cat action.yaml | grep -A 1000 "run: |" | tail -n +2))
EXIT_CODE=$?

# Verify the script exited with code 1
if [ $EXIT_CODE -eq 1 ]; then
  echo "✅ Script correctly exited with code 1 when file not found"
else
  echo "❌ Script did not exit with code 1 when file not found (got $EXIT_CODE)"
  exit 1
fi

echo "🎉 All tests passed for missing file scenario!"