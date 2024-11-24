resource "aws_s3_bucket" "mybucket7" {
  bucket = var.Bucketname
}

resource "aws_s3_bucket_ownership_controls" "example" {   #ownership
  bucket = aws_s3_bucket.mybucket7.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Private/ Publicly readable
resource "aws_s3_bucket_public_access_block" "example" { 
  bucket = aws_s3_bucket.mybucket7.id

  block_public_acls       = false      #all True if block public access
  block_public_policy     = false      
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {   
  bucket = aws_s3_bucket.mybucket7.id
  acl    = "public-read"                   #private if block public access

  depends_on = [aws_s3_bucket_ownership_controls.example]
}

# Upload objects
# resource "aws_s3_object" "error" {   
#   bucket = aws_s3_bucket.mybucket7.id
#   key    = "error.html"
#   source = "c:/Users/singapore traders/Desktop/Simple Html/Error.html"
#   acl = "public-read"                 #private if block public access
#   content_type = "text/html"
# }

# resource "aws_s3_object" "profile" {
#   bucket = aws_s3_bucket.mybucket7.id
#   key    = "profile.png"
#   source = "c:/Users/singapore traders/Desktop/Simple Html/profile.png"
#   acl = "public-read"
# }

#Only when hosted publicly NOT IN PRIVATE HOSTING
# resource "aws_s3_bucket_website_configuration" "website" {
#   bucket = aws_s3_bucket.mybucket7.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "Error.html"
#   }

#   depends_on = [ aws_s3_bucket_acl.example ]
# }