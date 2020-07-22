from urllib import request
import json, os, boto3


def send_to_slack(message):
    url = os.environ['SLACK_WEBHOOK']
    body = {"text": message}
    bytes = json.dumps(body).encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, bytes)


# entry point of lambda
def main(event, context):
    send_to_slack("```" + json.dumps(event) + "```")

    raceResults = [
        {'date': '07/22/2020',
         'driver': 'Lewis Hamilton',
         'track': 'Austria',
         'position': '1'},
        {'date': '07/22/2020',
         'driver': 'Max Verstappen',
         'track': 'Austria',
         'position': '2'}
    ]

    response = {
        'statusCode': 200,
        'headers': {
            "x-custom-header": "my custom header value",
            "Access-Control-Allow-Origin": "*"
        },
        'body': json.dumps(raceResults)
    }

    send_to_slack("```" + json.dumps(response) + "```")

    return response
