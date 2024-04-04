# AWS CLI Management Tool

This tool simplifies the process of starting and stopping AWS EC2 instances based on specific tags. It allows for easy management of instances across different profiles, particularly useful for users with multiple AWS accounts or configurations.

## Prerequisites

- AWS CLI v2 installed on your machine.
- Proper AWS IAM permissions to start and stop EC2 instances.
- Configured AWS SSO sessions for seamless authentication across profiles.

## Configuration File Setup

Before using this tool, you must have a configuration file set up with your AWS profiles. This file is crucial for the script to authenticate and perform actions on your behalf. Below is a generic template for your configuration file:

```plaintext
[profile YOUR_PROFILE_NAME]
sso_session = YOUR_SSO_SESSION
sso_account_id = YOUR_ACCOUNT_ID
sso_role_name = YOUR_ROLE_NAME
region = YOUR_PREFERRED_REGION

[sso-session YOUR_SSO_SESSION]
sso_start_url = YOUR_SSO_START_URL
sso_region = YOUR_SSO_REGION
sso_registration_scopes = sso:account:access
```

Replace placeholders (`YOUR_PROFILE_NAME`, `YOUR_SSO_SESSION`, etc.) with your specific AWS account and SSO details.

### Example Configuration

```plaintext
[profile my_aws_profile]
sso_session = my_sso_session
sso_account_id = 123456789012
sso_role_name = MyPowerUserRole
region = us-west-2

[sso-session my_sso_session]
sso_start_url = https://my-sso-start-url.awsapps.com/start
sso_region = us-west-2
sso_registration_scopes = sso:account:access
```

## Usage

The tool supports starting and stopping instances based on a command line argument (`start` or `stop`) and uses a configuration file for AWS profile settings.

### Command Syntax

```bash
aws_sbx3.bat [start|stop] -f [path_to_configuration_file]
```

### Example

To start instances:

```cmd
aws_sbx3.bat start -f path\to\your\config_file.config
```

To stop instances:

```cmd
aws_sbx3.bat stop -f path\to\your\config_file.config
```

## Configuration File Detailed Description

The configuration file (`-f` option) is crucial for the tool's operation, dictating which AWS profiles and instances the script interacts with. Below is a detailed breakdown of the configuration file's contents:

### Structure

The configuration file should be structured as a series of key-value pairs, each on a new line. The key elements include:

- `PROFILE`: Specifies the AWS CLI profile to use. This profile should be configured with the necessary permissions and credentials.
- `TAGKEY`: The key part of the tag that the script will look for when identifying EC2 instances to start or stop.
- `TAGVALUE`: The value part of the tag used in conjunction with `TAGKEY` to identify relevant EC2 instances.

### Sample Configuration File

```plaintext
PROFILE=example_profile
TAGKEY=Project
TAGVALUE=ExampleProject
```

### Explanation of Parameters

- `PROFILE`: This should match an AWS CLI profile name as defined in your AWS credentials configuration. The profile contains the access key, secret key, and any session tokens or SSO information required to authenticate API requests.
  
- `TAGKEY` and `TAGVALUE`: These are used to filter EC2 instances. For example, if your instances are tagged with `Project=ExampleProject`, you would set `TAGKEY` to `Project` and `TAGVALUE` to `ExampleProject`. The script will then target instances with this specific tag for starting or stopping operations.

### Creating the Configuration File

1. Create a new text file in your preferred text editor.
2. Enter the required `PROFILE`, `TAGKEY`, and `TAGVALUE` information, each on its own line.
3. Save the file with a `.config` extension in a secure location.

Ensure the configuration file's path is correctly specified when running the script with the `-f` option, as incorrect paths will prevent the script from executing as intended.

## Managing Instances with `manage_instances.bat`

The `manage_instances.bat` script provides a convenient way to start or stop multiple AWS EC2 instances across different profiles by automatically detecting and utilizing configuration files. This script simplifies the process of managing instances for users with multiple configurations.

### Features

- **Automatic Configuration Detection:** Automatically finds and uses all `.config` files in the specified directory.
- **Flexible Instance Management:** Allows starting or stopping instances across multiple profiles with a single command.

### Prerequisites

- Ensure you have followed the setup instructions in the [Configuration File Setup](#configuration-file-setup) section.
- Place all your `.config` files in the `configs` directory. The script is designed to automatically detect these files.

### Usage

To use `manage_instances.bat`, simply provide a single command line argument (`start` or `stop`) to specify the desired action. The script will apply this action to all instances defined in the `.config` files located in the `configs` directory.

#### Starting Instances

```cmd
manage_instances.bat start
```

This command will start all EC2 instances defined in the configuration files within the `configs` directory.

#### Stopping Instances

```cmd
manage_instances.bat stop
```

This command will stop all EC2 instances defined in the configuration files within the `configs` directory.

### Configuration Directory

By default, the script expects a directory named `configs` at the same level as the `manage_instances.bat` script. Ensure this directory contains your `.config` files, each configured as described in the [Configuration File Setup](#configuration-file-setup) section.

## Contributing

Contributions are welcome. Please open an issue first to discuss what you would like to change or add.

## License

[MIT](https://choosealicense.com/licenses/mit/)
