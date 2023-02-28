resource "aws_s3_bucket" "buckets3" {
  bucket = "bucket-s3-desafio-02-magno"

  lifecycle {
    #create_before_destroy = true
    prevent_destroy = true
    ignore_changes = [tags,]
  }
}