# chip-cloud-resume

How was this built?
- AWS SSO with a development account.
- Public S3 static web page that's served by a cloudfront distribution
- Domain purchased through google and pointing to the NS records of a route 53 hosted zone
- HTML, CSS, and a dash of JS for the frontend code
- DynamoDB table in order to store the visitor count
- Lambda functions for both the GET and PUT method actions
- API Gateway to serve those functions.
- A cloudfront distribution for fast delivery.
