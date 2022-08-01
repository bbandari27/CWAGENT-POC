# Creates linux instance with basic configuration with the instance profile, IAM policy.

# IAM Role for cwa  

resource "aws_iam_role" "cwa_role" {
 name   = "cwa_role"
 tags = merge(
  local.standard_tags
 )
 assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# IAM policy for cwa 

resource "aws_iam_policy" "cwa_policy" {

  name         = "cwa_policy"
  path         = "/"
  description  = "IAM policy for cwa"
  tags = merge(
    local.standard_tags
  )
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PermissionsNeededFor",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "organizations:*",
                "ssm:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# cwa_policy Attachment on the cwa_role.

resource "aws_iam_role_policy_attachment" "cwa_policy_attach" {
  role        = aws_iam_role.cwa_role.name
  policy_arn  = aws_iam_policy.cwa_policy.arn
}

# SSM_managed_policy Attachment on the cwa_role.

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role        = aws_iam_role.cwa_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# instance_profile for the CWA server EC2 Instance

resource "aws_iam_instance_profile" "CWA_instance_profile" {
  name = "CWA_instance_profile"
  role = aws_iam_role.cwa_role.name
}

# security group for the CWA server

resource "aws_security_group" "cwa_sg" {
  name        = "cwa_sg"
  description = "security group for CWA Server"
  vpc_id      = "vpc-cd1006b7"
  ingress {
    description      = "Open hhtps to Internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/8"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(
    local.standard_tags
  )
}

# EC2 instance for CWA server

resource "aws_instance" "cwa" {
  ami           = "ami-0b0af3577fe5e3532" # us-east-1
  instance_type = "c5.2xlarge"
  tags = merge(
    local.standard_tags,
    {
      Name = "cwa"
    }
  )
  root_block_device {
    delete_on_termination = true
    encrypted             = true
  }
  subnet_id = "subnet-0cf00a6a"
  iam_instance_profile = aws_iam_instance_profile.CWA_instance_profile.name
  vpc_security_group_ids = [
    aws_security_group.cwa_sg.id
  ]
  user_data = filebase64("userdata.sh")
}
