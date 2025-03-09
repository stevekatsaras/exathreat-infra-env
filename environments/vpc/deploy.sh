#!/bin/bash
ENVIRONMENT=$1
AWS_REGION=$2
TFSTATE_KEY="vpc/$ENVIRONMENT-exathreat.tfstate"
TF_BUCKET="$AWS_REGION-exathreat-tfstate"
AWS_REGION=$AWS_REGION
AWS_PROFILE="default"
AWS_CREDENTIALS_FILE=$(echo $HOME/.aws/credentials)

rm -rf tfplan .terraform
rm -rf live.tf alpha.tf beta.tf

cp "../vars/${AWS_REGION}/${ENVIRONMENT}.tf" .

terraform init -backend=true \
	-backend-config="bucket=$TF_BUCKET" \
	-backend-config="key=$TFSTATE_KEY" \
	-backend-config="profile=$AWS_PROFILE" \
	-backend-config="shared_credentials_file=$AWS_CREDENTIALS_FILE" \
	-backend-config="region=$AWS_REGION"

terraform plan $3 -out=tfplan -input=false