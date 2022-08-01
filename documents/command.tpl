{
  "schemaVersion": "2.2",
  "description": "The AWS-InstallAndManageCloudWatch command document installs the Amazon CloudWatch agent and manages the configuration of the agent for Amazon EC2 instances.",
  "mainSteps": [
    {
      "inputs": {
        "documentParameters": {
          "name": "AmazonCloudWatchAgent",
          "action": "Install"
        },
        "documentType": "SSMDocument",
        "documentPath": "AWS-ConfigureAWSPackage"
      },
      "name": "installCWAgent",
      "action": "aws:runDocument"
    },
    {
      "inputs": {
        "documentParameters": {
          "mode": "ec2",
          "optionalRestart": "yes",
          "optionalConfigurationSource": "default",
          "action": "configure"
        },
        "documentType": "SSMDocument",
        "documentPath": "AmazonCloudWatch-manageCWAgent"
      },
      "name": "manageCWAgent",
      "action": "aws:runDocument"
    }
  ]
}
