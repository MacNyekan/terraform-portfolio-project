terraform {
  backend "s3" {
    bucket         = "mn-my-tf-website-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-website-lock-file"
  }
}
