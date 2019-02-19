variable "name" {}

resource "aws_s3_bucket" "bucket" {
    bucket = "${var.name}"
    acl = "public-read"

    policy = <<EOF
{
          "Version": "2012-10-17",
          "Statement": [
            {
                "Sid": "AddPerm",
                "Effect": "Allow",
                "Principal": "*",
                "Action": ["s3:GetObject"],
                "Resource":["arn:aws:s3:::${var.name}/*"]
            }
          ]
}
EOF
        
    website {
        index_document = "index.html"

        error_document = "404.html"
    }
}

output "bucket" {
    value = "${aws_s3_bucket.bucket.bucket}"
}