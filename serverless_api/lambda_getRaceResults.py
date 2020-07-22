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

    # TODO from from dynamo db
    client = boto3.client('dynamodb')

    response = client.scan(TableName="RaceResults");
    race_result_items = response["Items"]

    send_to_slack("```" + json.dumps(response) + "```")

    race_results = []

    for race_result_item in race_result_items:
        date = race_result_item["Date"]["S"]
        driver = race_result_item["Driver"]["S"]
        track = race_result_item["Track"]["S"]
        position = race_result_item["Position"]["S"]

        race_results.append({
            'date': date,
            'driver': driver,
            'track': track,
            'position': position
        })

    response = {
        'statusCode': 200,
        'headers': {
            "x-custom-header": "my custom header value",
            "Access-Control-Allow-Origin": "*"
        },
        'body': json.dumps(race_results)
    }

    send_to_slack("```" + json.dumps(response) + "```")

    return response
