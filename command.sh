#!/bin/bash

set -euo pipefail

# Enable Debugging
set -x

# Function to execute Terraform command with error handling
run_terraform_command() {
  echo "Executing: $1"
  $1
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    echo "Error: Command failed with exit status $exit_status"
    exit $exit_status
  fi
}

# Get Terraform version
run_terraform_command "terraform version"

# Initialize Terraform
run_terraform_command "terraform init -upgrade"

# Define environments
environments=("dev" "test" "prod")

# Initialize variables
environment_choice=""
delete_environment=false

# Parse command-line options
while getopts ":e:d" opt; do
  case $opt in
    e)
      environment_choice="$OPTARG"
      ;;
    d)
      delete_environment=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Validate environment choice
if [[ "$environment_choice" != "dev" && "$environment_choice" != "test" && "$environment_choice" != "prod" ]]; then
  echo "Error: Invalid environment choice. Please choose dev, test, or prod."
  exit 1
fi

# Loop through environments
for environment in "${environments[@]}"; do
  # Check if the choice matches the current environment
  if [ "$environment_choice" == "$environment" ]; then
    echo "Processing environment: $environment"

    # Plan changes
    run_terraform_command "terraform plan -out ./$environment/$environment.tfplan -state ./$environment/$environment.tfstate -var-file ./$environment/$environment.tfvars"

    # Apply or destroy changes based on user choice
    if [ "$delete_environment" == true ]; then
      run_terraform_command "terraform destroy -state ./$environment/$environment.tfstate -var-file ./$environment/$environment.tfvars"
    else
      run_terraform_command "terraform apply -state ./$environment/$environment.tfstate ./$environment/$environment.tfplan"
    fi

    # Introduce a delay before processing the next environment
    sleep 60  # Adjust the delay as needed
  fi
done

echo "Script completed successfully."
exit 0
