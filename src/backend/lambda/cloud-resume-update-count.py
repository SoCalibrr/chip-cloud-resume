import json
import logging
import os
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chip-cloud-resume-counter')


def lambda_handler(event, context):
    '''PUT the updated visit_count in DynamoDB'''
    get_visitors = table.get_item(Key={
            'record_id':'0'
    })
    visit_count = int(get_visitors['Item']['visit_count'])
    visit_count += 1
    print(f"Please welcome our {visit_count} visitor!")
    table.put_item(Item={
            'record_id':'0',
            'visit_count': visit_count
    })

    data = {"visit_count": visit_count}

    response = {
        "statusCode": 200,
        "body": json.dumps(data),
        "visitors": visit_count,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Headers": "Content-Type, Origin",
            "Access-Control-Allow-Origin": os.getenv("WEBSITE_CLOUDFRONT_DOMAIN", "*"),
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
        },
    }

    return response
