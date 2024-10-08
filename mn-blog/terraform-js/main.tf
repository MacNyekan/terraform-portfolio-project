provider "aws" {
  region = "us-east-1"
}

#s3 bucket
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "mn-nextjs-portfolio-bucket-ss"

}

#ownership controls (only owner has access to objects)
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  rule {
    object_ownership = "BucketOwnerPrefferred"
  }

}

#Block Public access (mange publick access against unauthorized public access)
resource "aws_s3_bucket_public_access_block" "nextjs_bucket_Public_access_block" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Bucket ACL (define access)
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.nextjs,
    awaws_s3_bucket_public_access_block.nextjs_bucket_Public_access_block
  ]
  bucket = aws_s3_bucket.nextjs_bucket.id
  acl    = "public-read"
}

#bucket policy (define detailed access permissions for buckt and objects)
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  policy = jsondecode(({
    version = "2012-10-17"
    statemetn = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.nextjs_bucket.arn}/*"
      }
    ]

  }))

}
