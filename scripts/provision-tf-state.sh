#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="feedback-tool-tf-state"
BUCKET_NAME="terraform-state"
REGION="europe-1"
USERNAME_BASE="terraform"
ENVS="
dev
prod
"

gh auth status 1> /dev/null

upctl_json() { upctl -o json "$@"; }

# Create or find the object storage service
echo "checking for object storage service '$SERVICE_NAME'..."
service_uuid=$(upctl_json object-storage list | \
  jq -r --arg n "$SERVICE_NAME" '.[] | select(.name == $n) | .uuid' | head -1)

if [[ -z "$service_uuid" ]]; then
  echo "creating object storage service '$SERVICE_NAME' in region '$REGION'..."
  service_uuid=$(upctl_json object-storage create \
    --name "$SERVICE_NAME" \
    --region "$REGION" \
    --wait | jq -r '.uuid')
  echo "created: $service_uuid"
else
  echo "found existing service: $service_uuid"
fi

# Create bucket
echo "creating bucket '$BUCKET_NAME'..."
upctl object-storage bucket create "$service_uuid" --name "$BUCKET_NAME" || \
    echo "bucket may already exist, continuing..."

endpoint=$(upctl_json object-storage show "$service_uuid" | jq -r '.endpoint_url // .endpoints[0].domain_name')

declare -A access_key_id
declare -A secret_access_key

for env in $ENVS; do
    # Create user if it doesn't exist
    USERNAME="$USERNAME_BASE-$env"
    echo "checking for user '$USERNAME'..."
    arn=$(upctl_json object-storage user list "$service_uuid" | \
      jq -r --arg u "$USERNAME" '.[] | select(.username == $u) | .arn' | head -1)

    if [[ -z "$arn" ]]; then
      echo "creating user '$USERNAME'..."
      upctl object-storage user create "$service_uuid" --username "$USERNAME"
    fi

    # Create access key (secret shown only once)
    echo "creating access key for '$USERNAME'..."
    key=$(upctl_json object-storage access-key create "$service_uuid" --username "$USERNAME")
    access_key_id[$env]=$(echo "$key" | jq -r '.access_key_id')
    secret_access_key[$env]=$(echo "$key" | jq -r '.secret_access_key')

    POLICY="$(jq -c '.' << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        "Resource": "arn:aws:s3:::terraform-state/$env/terraform.tfstate",
        "Effect": "Allow"
        },
        {
        "Action": ["s3:ListBucket", "s3:GetBucketVersioning"],
        "Resource": "arn:aws:s3:::terraform-state",
        "Effect": "Allow"
        }
    ]
}
EOF
    )"

    echo "adding terraform bucket access policy to user '${USERNAME}'"
    curl -X POST "https://api.upcloud.com/1.3/object-storage-2/${service_uuid}/users/${USERNAME}/inline-policies" \
        -s -f -o /dev/null \
        -H "Host: api.upcloud.com" \
        -H "Authorization: Bearer $UPCLOUD_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$(jq -c -n \
            --arg content "$POLICY" \
            '{
                "name": "TFStateFullAccess",
                "document": $content
            }')"

done

echo "Setting github variables and secrets..."
gh variable set TF_STATE_BUCKET_ENDPOINT --body "https://$endpoint"
for env in $ENVS; do
    gh variable set TF_STATE_ACCESS_KEY_ID --env "$env" --body "${access_key_id[$env]}"
    gh secret set TF_STATE_SECRET_ACCESS_KEY --env "$env" --body "${secret_access_key[$env]}"
done

echo -e "Provisioning complete for \n"
echo REGION="$REGION"
echo BUCKET_NAME="$BUCKET_NAME"
echo AWS_ENDPOINT_URL="https://$endpoint"

echo The following terraform state users were generated:
for env in $ENVS; do
    cat << EOF

USERNAME=$USERNAME_BASE-$env
AWS_ACCESS_KEY_ID=${access_key_id[$env]}
AWS_SECRET_ACCESS_KEY=${secret_access_key[$env]}

EOF
done

echo "WARNING: The secret keys are only shown once and cannot be retrieved again."

cat << EOF

Use the following snippet to configure terraform backend:

backend "s3" {
    bucket = "terraform-state"
    key    = "<environment>/terraform.tfstate"
    region = "europe-1"
    endpoints = {
        s3 = "https://hsu3i.upcloudobjects.com"
        iam = "https://hsu3i.upcloudobjects.com:4443/iam"
        sts = "https://hsu3i.upcloudobjects.com:4443/sts"
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = false
}
EOF
