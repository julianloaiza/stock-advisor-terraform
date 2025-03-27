terraform {
  backend "s3" {
    bucket         = "stock-advisor-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"  # Cambiar a tu región preferida
    dynamodb_table = "stock-advisor-terraform-locks"
    encrypt        = true
  }
}
