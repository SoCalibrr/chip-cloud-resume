import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chip-cloud-resume-counter')


def lambda_handler(event, context):
    '''GET the visit count from DynamoDB'''
    response = table.get_item(Key={
       'record_id':'0'
    })

   data = {'visit_count': visit_count}

   response = {
        "statusCode": 200,
        "body": json.dumps(data),
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Headers": "Content-Type, Origin",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
        },
    }
    return int(response['Item']['visit_count'])
