terraform {
  backend "s3" {
    bucket         = "vasanth-backend-bucket-s3"
    key            = "dev.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
