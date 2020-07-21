from urllib import request
import json, os, boto3


def send_to_slack(message):
    url = ''
    body = {"text": message}
    bytes = json.dumps(body).encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, bytes)


# entry point of lambda
def send_message(event, context):
    send_to_slack("```" + json.dumps(event) + "```")

    queryStringParameters = event["queryStringParameters"]
    # print(queryStringParameters)

    startTag = queryStringParameters["startTag"]
    endTag = queryStringParameters["endTag"]
    repositoryName = queryStringParameters["repositoryName"]

    # print(startTag)
    # print(endTag)
    # print(repositoryName)

    # get start commit id
    client = boto3.client('dynamodb')

    response = client.get_item(
        Key={
            'RepositoryName': {
                'S': repositoryName,
            },
            'Tag': {
                'S': startTag,
            },
        },
        TableName='CodeCommitTags',
    )

    startCommitId = response["Item"]["CommitId"]["S"]
    # print(startCommitId)

    # get end commit id
    client = boto3.client('dynamodb')

    response = client.get_item(
        Key={
            'RepositoryName': {
                'S': repositoryName,
            },
            'Tag': {
                'S': endTag,
            },
        },
        TableName='CodeCommitTags',
    )

    endCommitId = response["Item"]["CommitId"]["S"]
    # print(endCommitId)

    client = boto3.client('codecommit')
    startCommitInfo = client.get_commit(repositoryName=repositoryName, commitId=startCommitId)
    # print(startCommitInfo)
    startCommitId = startCommitInfo['commit']['commitId']

    endCommitInfo = client.get_commit(repositoryName=repositoryName, commitId=endCommitId)
    # print(endCommitInfo)
    endCommitId = endCommitInfo['commit']['commitId']

    nextCommitId = endCommitInfo['commit']['parents'][0]

    # start from endCommit Id and collect commit messages

    commitMessages = []
    commitMessages.append(endCommitInfo['commit']['message'])

    # we only process 100 commit message at a time, which is better than doing
    # a while true loop that potentially never ends
    for x in range(100):
        # print(x)

        commitInfo = client.get_commit(repositoryName=repositoryName, commitId=nextCommitId)
        commitId = commitInfo['commit']['commitId']
        # print(commitInfo)

        if commitId == startCommitId:
            # print("we have reached the start")
            # commitMessages.append(commitInfo['commit']['message'])
            break
        else:
            # print("collect commit message")
            commitMessages.append(commitInfo['commit']['message'])
            nextCommitId = commitInfo['commit']['parents'][0]

    # print(commitMessages)
    # print("done")

    response = {
        'statusCode': 200,
        'headers': {
            "x-custom-header": "my custom header value",
            "Access-Control-Allow-Origin": "*"
        },
        'body': json.dumps(commitMessages)
    }

    return response
