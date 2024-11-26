# https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds#advanced_scenarios

import sys
import json
import urllib

import boto3
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest


def create_token_aws(project_number: str, pool_id: str, provider_id: str) -> None:
    request = AWSRequest(
        method="POST",
        url="https://sts.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15",
        headers={
            "Host": "sts.amazonaws.com",
            "x-goog-cloud-target-resource": f"//iam.googleapis.com/projects/{project_number}/locations/global/workloadIdentityPools/{pool_id}/providers/{provider_id}",
        },
    )

    SigV4Auth(boto3.Session().get_credentials(), "sts", "us-east-1").add_auth(request)

    token = {"url": request.url, "method": request.method, "headers": []}
    for key, value in request.headers.items():
        token["headers"].append({"key": key, "value": value})

    print("Token:\n%s" % json.dumps(token, indent=2, sort_keys=True))
    print("URL encoded token:\n%s" % urllib.parse.quote(json.dumps(token)))


def main() -> None:
    project_number = sys.argv[1]
    pool_id        = sys.argv[2]
    provider_id    = sys.argv[3]

    create_token_aws(project_number, pool_id, provider_id)

if __name__ == "__main__":
    main()
