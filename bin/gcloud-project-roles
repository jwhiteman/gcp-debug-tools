#!/bin/bash
# (g)et (p)roject (r)oles

if [ "$#" -ne 2 ]; then
      echo "Usage: $0 <PROJECT_ID> <SERVICE_ACCOUNT_EMAIL>"
          exit 1
fi

PROJECT_ID=$1
SERVICE_ACCOUNT_EMAIL=$2

gcloud projects get-iam-policy "$PROJECT_ID" \
  --flatten="bindings[].members" \
  --filter="bindings.members:$SERVICE_ACCOUNT_EMAIL" \
  --format="table(bindings.role)"
