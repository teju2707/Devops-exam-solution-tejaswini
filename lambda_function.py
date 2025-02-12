import json
import requests

def lambda_handler(event, context):
    url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
    headers = {
        'X-Siemens-Auth': 'test',
        'Content-Type': 'application/json'
    }
    payload = {
        "subnet_id": event["subnet_id"],
        "name": event["name"],
        "email": event["email"]
    }
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    return {
        'statusCode': response.status_code,
        'body': response.text
    }
