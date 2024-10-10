data "aws_partition" "current" {}

data "aws_region" "current" {}

data "external" "thumbprint" {
  program = ["${path.module}/thumbprint.sh", data.aws_region.current.name]
}
