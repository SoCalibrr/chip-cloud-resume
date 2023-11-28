resource "aws_route53_zone" "primary" {
  name = "calvinwilson.app"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "calvinwilson.app"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = "d3fc32iwpgccnl.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}
