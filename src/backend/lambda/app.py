import json
import logging
import os
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

client = boto3.resource("dynamodb", region_name=os.getenv("REGION", "es-east-1"))
dynamodb_table = client.Table(os.getenv("chip-cloud-resume-counter"))


def handler(event, context):
    response = dynamodb_table.get_item(Key={"record_id": 0})

    if "Item" not in response:
        logging.info("No Visitor Counter in DynamoDB Table. Creating...")
        dynamodb_table.put_item(
            Item={"record_id": 0, "visit_count": 0},
        )
        current_visit_count = 1
    else:
        # Convert from decimal.Decimal to int
        current_visit_count = int(response["Item"]["visit_count"]) + 1

    logging.info("Incrementing visit_count counter by 1")
    dynamodb_table.update_item(
        Key={"record_id": 0},
        UpdateExpression="SET visit_count = visit_count + :newVisitor",
        ExpressionAttributeValues={":newVisitor": 1},
    )

    data = {'visit_count': current_visit_count}

    response = {
        "statusCode": 200,
        "body": json.dumps(data),
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Headers": "Content-Type, Origin",
            "Access-Control-Allow-Origin": os.getenv("WEBSITE_CLOUDFRONT_DOMAIN", "*"),
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
        },
    }

    return response
