## Script Overview

1. **`set -euo pipefail`**
    - `set -e`: Exit immediately if any command exits with a non-zero status (i.e., encounters an error).
    - `set -u`: Treat references to unset variables as errors.
    - `set -o pipefail`: Consider a pipeline as failed if any command in the pipeline fails.

2. **`set -x`** 
    - Enable debugging mode, printing each command to stderr before executing it. Useful for understanding the script's execution flow.

3. **`run_terraform_command` function:**
    - A function that takes a Terraform command as an argument, executes it, and handles errors.
    - The command is echoed for visibility.
    - The exit status of the command is checked, and if it's non-zero, an error message is printed, and the script exits with the same status.

4. **Terraform Commands:**
    - `terraform version`: Retrieves and prints the Terraform version.
    - `terraform init`: Initializes the Terraform working directory.
    - `terraform fmt`: Formats the Terraform code.

5. **Command-line Options:**
    - `-e`: Specifies the target environment (e.g., dev, test, or prod).
    - `-d`: Indicates the intention to delete resources.

6. **Parsing Command-line Options:**
    - The script uses `getopts` to parse command-line options and sets corresponding variables (`environment_choice` and `delete_environment`).

7. **Environment Validation:**
    - Ensures that the specified environment is one of the valid choices (dev, test, or prod).

8. **Loop Through Environments:**
    - Iterates over the defined environments.
    - For the chosen environment, it executes Terraform commands (plan and either apply or destroy based on the user's choice).  


## Executing the bash script.
Here are the commands to run the script:

|   Commands                  |  Purpose                                     |
| :-----------------------:   | :------------------------------------------:|
| `./command.sh -e test`      | Deploy Resources to the Test environment    |
| `./command.sh -e dev`       | Deploy Resources to the Dev environment     |
| `./command.sh -e prod`      | Deploy Resources to the Prod environment    |
| `./command.sh -e test -d`   | Delete Resources from the Test environment  |
| `./command.sh -e dev -d`    | Delete Resources from the Dev environment   |
| `./command.sh -e prod -d`   | Delete Resources from the Prod environment  |
