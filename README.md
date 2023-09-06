# chip-cloud-resume

How was this built?
- AWS SSO with a development account.
- Public S3 static web page that's served by a cloudfront distribution
- Domain purchased through google and pointing to the NS records of a route 53 hosted zone
- HTMl and CSS for the frontend code (Possible to include any JS on a static website?)
- DynamoDB table in order to store the visitor count
- Lambda functions for both the GET and PUT method actions
- A lambda gateway to serve those functions
