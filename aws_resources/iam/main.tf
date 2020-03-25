provider "aws" {
  region = var.region
}

resource "aws_iam_instance_profile" "hkw_profile" {
  name = "${var.prefix}_profile"
  role = aws_iam_role.main_role.name
}

resource "aws_iam_role" "main_role" {
  name = "${var.prefix}_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "${var.prefix}_role"
  }
}

resource "aws_iam_policy" "hkw_policy" {
  name        = "${var.prefix}_policy"
  description = "Terraform managed, cloudwatch put and get metrics"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "ec2:DescribeTags"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "hkw-attach" {
  name       = "${var.prefix}_attach"
  roles      = ["${aws_iam_role.main_role.name}"]
  policy_arn = aws_iam_policy.hkw_policy.arn
}
