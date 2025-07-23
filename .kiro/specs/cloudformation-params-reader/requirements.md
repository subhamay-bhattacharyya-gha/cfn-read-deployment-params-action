# Requirements Document

## Introduction

This feature involves creating a GitHub reusable action that reads CloudFormation deployment parameters from a JSON artifact file. The action will parse the deployment configuration and expose the parameters, stack name, and template path as outputs for use in subsequent workflow steps. This enables standardized parameter extraction across multiple repositories and deployment workflows.

## Requirements

### Requirement 1

**User Story:** As a DevOps engineer, I want a reusable GitHub action that reads CloudFormation parameters from a JSON file, so that I can standardize parameter extraction across multiple deployment workflows.

#### Acceptance Criteria

1. WHEN the action is invoked THEN the system SHALL accept an optional `artifact-path` input parameter
2. IF no `artifact-path` is provided THEN the system SHALL default to `./artifacts/deployment.json`
3. WHEN the action executes THEN the system SHALL attempt to read the specified JSON file
4. IF the JSON file exists THEN the system SHALL parse the file contents
5. IF the JSON file does not exist THEN the system SHALL exit with error code 1 and display an error message

### Requirement 2

**User Story:** As a developer, I want the action to extract specific CloudFormation configuration values from the JSON file, so that I can use them in subsequent workflow steps.

#### Acceptance Criteria

1. WHEN parsing the JSON file THEN the system SHALL extract the `parameters` field as compact JSON
2. WHEN parsing the JSON file THEN the system SHALL extract the `stack-name` field as a string
3. WHEN parsing the JSON file THEN the system SHALL extract the `template-path` field as a string
4. WHEN extraction is successful THEN the system SHALL display the extracted values in the workflow logs
5. IF any required field is missing THEN the system SHALL handle the error gracefully

### Requirement 3

**User Story:** As a workflow author, I want the extracted values available as action outputs, so that I can reference them in subsequent steps using the standard GitHub Actions syntax.

#### Acceptance Criteria

1. WHEN extraction is successful THEN the system SHALL set `parameters` as an action output containing compact JSON
2. WHEN extraction is successful THEN the system SHALL set `stack-name` as an action output
3. WHEN extraction is successful THEN the system SHALL set `template-path` as an action output
4. WHEN the action completes THEN all outputs SHALL be accessible via `steps.<step-id>.outputs.<output-name>` syntax

### Requirement 4

**User Story:** As a workflow author, I want the extracted values available as environment variables, so that I can use them in bash scripts and other workflow steps that don't support action outputs.

#### Acceptance Criteria

1. WHEN extraction is successful THEN the system SHALL set `DEPLOYMENT_PARAMETERS` as a multiline environment variable
2. WHEN extraction is successful THEN the system SHALL set `DEPLOYMENT_STACK_NAME` as an environment variable
3. WHEN extraction is successful THEN the system SHALL set `DEPLOYMENT_TEMPLATE_PATH` as an environment variable
4. WHEN the action completes THEN all environment variables SHALL be available in subsequent workflow steps

### Requirement 5

**User Story:** As a repository maintainer, I want the action to be properly configured as a reusable GitHub action, so that other repositories can easily consume it.

#### Acceptance Criteria

1. WHEN the action is created THEN the system SHALL include a proper `action.yaml` metadata file
2. WHEN the action is defined THEN the system SHALL specify the correct input parameters with descriptions and defaults
3. WHEN the action is defined THEN the system SHALL specify the correct output parameters with descriptions
4. WHEN the action is published THEN other repositories SHALL be able to reference it using standard GitHub Actions syntax