resource "aws_s3_bucket" "efuse-bucket" {
    bucket = "agoro2022bucket"
}

resource "aws_s3_bucket_acl" "efuse-bucket-acl" {
    bucket = aws_s3_bucket.efuse-bucket.id
    acl    = "public-read"
}

resource "aws_s3_object" "temi_upload"{
    content = "/home/tagoro/terraform/temi.txt"
    key     = "temi.txt"
    bucket  = aws_s3_bucket.efuse-bucket.id
}

resource "aws_iam_user" "aws-terraform-user"{
    name = "efuse_user"
}
resource "aws_s3_bucket_policy" "temi-policy" {
    bucket   = aws_s3_bucket.efuse-bucket.id
    policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObjet",
                "S3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.efuse-bucket.id}/*",
            "Principal": {
                "AWS": [
                    "${resource.aws_iam_user.aws-terraform-user.arn}"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "efuse-bucket-block"{
    bucket   = aws_s3_bucket.efuse-bucket.id

    block_public_acls        = true 
    block_public_policy      = true
    ignore_public_acls       = true
    restrict_public_buckets  = true
}