##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
    region = "us-west-2",
    profile = "default",
    shared_credentials_file = "/home/ysnmll/.aws/credentials"
}

# S3 Bucket config#
module "www-domain-name" {
  source = "./Modules/s3"
  name = "${var.www_domain_name}"  
}

module "root-domain-name" {
    source = "./Modules/s3"
    name = "${var.root_domain_name}"
}
