import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chip-cloud-resume-counter')


def lambda_handler(event, context):
    '''GET the visit count from DynamoDB'''
    response = table.get_item(Key={
       'record_id':'0'
    })

    return int(response['Item']['visit_count'])
