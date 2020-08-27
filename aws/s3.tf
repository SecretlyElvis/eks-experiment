resource "aws_s3_bucket" "nexus" {
  bucket = "loyalty-nexus-object-store"
  acl    = "private"

  tags = {
    Name        = "Nexus Ojbect Store"
    Environment = "POC"
    CreatedBy   = "Terraform"
  }
}