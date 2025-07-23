# CloudFormation Parameters Reader

![Built with Kiro](https://img.shields.io/badge/Built%20with-Kiro-blue?style=flat&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJMMTMuMDkgOC4yNkwyMCA5TDEzLjA5IDE1Ljc0TDEyIDIyTDEwLjkxIDE1Ljc0TDQgOUwxMC45MSA4LjI2TDEyIDJaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4K)&nbsp;![GitHub Action](https://img.shields.io/badge/GitHub-Action-blue?logo=github)&nbsp;![Release](https://github.com/subhamay-bhattacharyya-gha/cfn-stack-params-action/actions/workflows/release.yaml/badge.svg)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![Bash](https://img.shields.io/badge/Language-Bash-green?logo=gnubash)&nbsp;![CloudFormation](https://img.shields.io/badge/AWS-CloudFormation-orange?logo=amazonaws)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/cfn-stack-params-action)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/4b247fb46db91d8488e878ac1b4d3920/raw/cfn-stack-params-action.json?)

A GitHub Action that reads CloudFormation deployment parameters from a JSON artifact file and makes them available as outputs and environment variables for use in subsequent workflow steps.

## Overview

This action simplifies CloudFormation deployments by standardizing how parameters are extracted from configuration files. It parses a JSON artifact file containing CloudFormation deployment configuration and exposes the parameters, stack name, and template path as both GitHub Actions outputs and environment variables.

## Features

- 📄 Reads deployment configuration from a JSON artifact file
- 🔍 Extracts CloudFormation parameters, stack name, and template path
- 🔌 Provides values as both GitHub Actions outputs and environment variables
- ⚠️ Handles errors gracefully with clear error messages
- 📝 Logs extracted values for easy debugging

## Inputs

| Name | Description | Required | Default |
|------|-------------|----------|---------|
| `artifact-path` | Path to the deployment.json artifact file | No | `./artifacts/deployment.json` |

## Outputs

| Name | Description |
|------|-------------|
| `parameters` | CloudFormation parameters in JSON format |
| `stack-name` | CloudFormation stack name |
| `template-path` | Path to CloudFormation template |

## Environment Variables

The action also sets the following environment variables:

| Name | Description |
|------|-------------|
| `DEPLOYMENT_PARAMETERS` | CloudFormation parameters in JSON format |
| `DEPLOYMENT_STACK_NAME` | CloudFormation stack name |
| `DEPLOYMENT_TEMPLATE_PATH` | Path to CloudFormation template |

## Usage

### Basic Usage

```yaml
- name: Extract CloudFormation Parameters
  uses: subhamay-bhattacharyya-gha/cfn-read-deployment-params-action@main
  id: cfn-params
```

### Custom Artifact Path

```yaml
- name: Extract CloudFormation Parameters
  uses: subhamay-bhattacharyya-gha/cfn-read-deployment-params-action@main
  id: cfn-params
  with:
    artifact-path: './custom/path/to/deployment.json'
```

### Using Outputs in Subsequent Steps

```yaml
- name: Deploy CloudFormation Stack
  run: |
    aws cloudformation deploy \
      --template-file ${{ steps.cfn-params.outputs.template-path }} \
      --stack-name ${{ steps.cfn-params.outputs.stack-name }} \
      --parameter-overrides ${{ steps.cfn-params.outputs.parameters }}
```

### Using Environment Variables in Subsequent Steps

```yaml
- name: Deploy Using Environment Variables
  run: |
    aws cloudformation deploy \
      --template-file $DEPLOYMENT_TEMPLATE_PATH \
      --stack-name $DEPLOYMENT_STACK_NAME \
      --parameter-overrides $DEPLOYMENT_PARAMETERS
```

## Input JSON Format

The action expects a JSON file with the following structure:

```json
{
  "parameters": {
    "ParameterKey1": "ParameterValue1",
    "ParameterKey2": "ParameterValue2"
  },
  "stack-name": "my-cloudformation-stack",
  "template-path": "./templates/infrastructure.yaml"
}
```

## Error Handling

The action will exit with an error code 1 in the following cases:
- The artifact file does not exist at the specified path
- The JSON file cannot be parsed correctly
- Required fields cannot be extracted from the JSON file

## Requirements

- This action requires `jq` to be available on the runner (pre-installed on GitHub-hosted runners)

## Examples

### Complete Workflow Example

```yaml
name: Deploy CloudFormation Stack

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Extract CloudFormation Parameters
        uses: subhamay-bhattacharyya-gha/cfn-read-deployment-params-action@v1
        id: cfn-params

      - name: Deploy CloudFormation Stack
        run: |
          aws cloudformation deploy \
            --template-file ${{ steps.cfn-params.outputs.template-path }} \
            --stack-name ${{ steps.cfn-params.outputs.stack-name }} \
            --parameter-overrides ${{ steps.cfn-params.outputs.parameters }} \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
```

## Testing

This action includes test scripts to validate functionality:

- `tests/test-valid-input.sh`: Tests that the action works with valid JSON input
- `tests/test-missing-file.sh`: Tests error handling when file is missing
- `tests/test-output-format.sh`: Tests that output format matches expected structure

Run the tests with:

```bash
chmod +x tests/*.sh
./tests/test-valid-input.sh
./tests/test-missing-file.sh
./tests/test-output-format.sh
```

## License

MIT