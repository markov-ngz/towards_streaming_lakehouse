

resource "aws_s3_bucket" "etl" {
  for_each = var.etl_bucket_names

  bucket = each.value

  tags = {
    Name = each.value
  }
}