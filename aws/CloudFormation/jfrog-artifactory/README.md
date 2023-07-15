aws cloudformation deploy --stack-name jfrog-artifactory-s3-bucket --template-file jfrog-artifactory-s3.yaml --parameter-overrides file://parameters/jfrog-artifactory-s3.properties --capabilities CAPABILITY_NAMED_IAM --region us-east-2 --profile aws-prd

or 

aws cloudformation deploy --stack-name jfrog-artifactory-s3-bucket --template-file jfrog-artifactory-s3.yaml --capabilities CAPABILITY_NAMED_IAM --region us-east-2 --profile aws-prd --parameter-overrides "BucketName=jfrog-artifactory-s3-bucket" "KMSKey=arn:aws:kms:us-east-2:{{ account }}:key/{{ key-id }}"

