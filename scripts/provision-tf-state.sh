#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="${SERVICE_NAME:-feedback-tool-tf-state}"
BUCKET_NAME="${BUCKET_NAME:-terraform-state}"
REGION="${REGION:-europe-1}"
USERNAME="${USERNAME:-terraform}"

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

endpoint=$(upctl_json object-storage show "$service_uuid" | jq -r '.endpoint_url // .endpoints[0].domain_name')

# Create user if it doesn't exist
echo "checking for user '$USERNAME'..."
user_exists=$(upctl_json object-storage user list "$service_uuid" | \
  jq -r --arg u "$USERNAME" '.[] | select(.username == $u) | .username' | head -1)

if [[ -z "$user_exists" ]]; then
  echo "creating user '$USERNAME'..."
  upctl object-storage user create "$service_uuid" --username "$USERNAME"
fi

# Create access key (secret shown only once)
echo "creating access key for '$USERNAME'..."
key=$(upctl_json object-storage access-key create "$service_uuid" --username "$USERNAME")
access_key_id=$(echo "$key" | jq -r '.access_key_id')
secret_access_key=$(echo "$key" | jq -r '.secret_access_key')

# Create bucket
echo "creating bucket '$BUCKET_NAME'..."
upctl object-storage bucket create "$service_uuid" --name "$BUCKET_NAME" || \
  echo "bucket may already exist, continuing..."

cat <<EOF

provisioning complete. add this backend block to each terraform environment
and replace the existing cloud {} block:

  backend "s3" {
    bucket                      = "$BUCKET_NAME"
    key                         = "<environment>/terraform.tfstate"
    region                      = "$REGION"
    endpoint                    = "https://$endpoint"
    access_key                  = "$access_key_id"
    secret_key                  = "$secret_access_key"
    skip_credentials_validation = true
    skip_region_validation      = true
    force_path_style            = false
  }

warning: the secret_key above is shown only once and cannot be retrieved again.
store it in a secrets manager before closing this terminal.
EOF
