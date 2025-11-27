terraform {
  backend "s3" {
    bucket = "backend0775"
    key = "ec2/terraform.tfstate"
    region = "ap-southeast-2"
    dynamodb_table = "backend"
    encrypt = true
  }
}
