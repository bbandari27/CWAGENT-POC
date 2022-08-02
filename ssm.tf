resource "aws_ssm_document" "InstallandmanageCWAgent" {
  name          = "InstallandmanageCWAgent"
  document_type = "Command"
  content = templatefile(var.template_path, 
    { 
      params = "",
      description = "The installandmanagecwAgent Document installs the CloudWatch Agent and manages the configuration of the agent for AWS Ec2 Instances"
    })
}

resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to custom configure"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("cw_agent_config.json")
}
