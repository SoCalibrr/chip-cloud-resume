import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chip-cloud-resume-counter')


def lambda_handler(event, context):
    '''PUT the updated visit_count in DynamoDB'''
    response = table.get_item(Key={
            'record_id':'0'
    })
    visit_count = response['Item']['visit_count']
    visit_count += 1
    print(f"Please welcome our {visit_count} visitor!")
    response = table.put_item(Item={
            'record_id':'0',
            'visit_count': visit_count
    })

    return visit_count
