
provider "aws" {
    region = "us-west-2",
    profile = "default",
    shared_credentials_file = "/home/ysnmll/.aws/credentials"
}

# S3 Bucket config #
#########################################
module "www-domain-name" {
  source = "./Modules/s3"
  name = "${var.www_domain_name}"  
}

module "root-domain-name" {
    source = "./Modules/s3"
    name = "${var.root_domain_name}"
}
#########################################

# Route53 configs #
#########################################
resource "aws_route53_zone" "primary" {
    name = "yasinmalli.com"
}

resource "aws_route53_record" "prod-ns" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.root_domain_name}"
    type = "NS"
    ttl = "172800"

    records = [
        "${aws_route53_zone.primary.name_servers.0}",
        "${aws_route53_zone.primary.name_servers.1}",
        "${aws_route53_zone.primary.name_servers.2}",
        "${aws_route53_zone.primary.name_servers.3}"
    ]
}

resource "aws_route53_record" "prod-soa" {
    count = "0"
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.root_domain_name}"
    type = "SOA"
    ttl = "900"

    records = [
        "${aws_route53_zone.primary.name_servers.0}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
    ]
}

resource "aws_route53_record" "prod-root-a" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.root_domain_name}"
    type = "A"

    alias {
        zone_id = "${module.root-domain-name.bucket_hosted_zone_id}"
        name = "${module.root-domain-name.bucket_website_endpoint}"
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "prod-www-a" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.www_domain_name}"
    type = "A"

    alias {
        zone_id = "${module.www-domain-name.bucket_hosted_zone_id}"
        name = "${module.www-domain-name.bucket_website_endpoint}"
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "prod-api" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "api.${var.root_domain_name}"
    type = "A"
    ttl = "300"

    records = [
        "54.203.166.136"
    ]
}