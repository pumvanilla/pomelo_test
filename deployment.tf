

resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "Server"
  name             = "web-server"
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  count      = "${length(var.ec2_policy)}"
  policy_arn = "${element(var.ec2_policy, count.index)}"
  role       = aws_iam_role.ec2_role.name
}


resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_policy" {
  count      = "${length(var.codedeploy_policy)}"
  policy_arn = "${element(var.codedeploy_policy, count.index)}"
  role       = aws_iam_role.codedeploy_role.name
}

resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "web-server-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "web server"
    }
  }
}

