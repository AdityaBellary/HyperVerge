import json
import boto3
import requests

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    message = ""
    
    for endpoint in event['endpoints']:
        try:
            response = requests.get(endpoint['url'], timeout=5)
            status_code = response.status_code
            
            if status_code != 200:
                message += f"Alert: {endpoint['name']} is down. Status code: {status_code}\n"
            else:
                message += f"{endpoint['name']} is healthy. Status code: {status_code}\n"
        except requests.exceptions.RequestException as e:
            message += f"Alert: {endpoint['name']} is down. Error: {str(e)}\n"
    
    if 'alert_topic' in event and message:
        sns_client.publish(
            TopicArn=event['alert_topic'],
            Message=message,
            Subject='API Health Check Alert'
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Health check completed.')
    }
