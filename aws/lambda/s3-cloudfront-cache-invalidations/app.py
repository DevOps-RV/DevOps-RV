"""Lambda function Create Cloudfront invalidations for updated objects in S3"""

import json
import time
import os
import boto3

s3_client = boto3.resource('s3')
cloudfront_client = boto3.client('cloudfront')
region = os.environ['AWS_REGION']


def lambda_handler(event, context):
    # Get the bucket and boject key from the S3 event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Check if the bucket is an origin for a CloudFront distribution
    cf_distro_id = get_cloudfront_distribution_id(bucket)
    if cf_distro_id:
        try:
            # Create an invalidation for the updated object
            invalidation = cloudfront_client.create_invalidation(
                DistributionId=cf_distro_id,
                InvalidationBatch={
                    'Paths': {
                        'Quantity': 1,
                        'Items': [ f"/{key}" ]
                    },
                    'CallerReference': str(time.time())
                })
            print(f"Submitted invalidation for s3 object: {key}, ID: {invalidation['Invalidation']['Id']}, Status: {invalidation['Invalidation']['Status']}")

        except Exception as e:
            print(f"Error processing object {key} from bucket {bucket}. Event {json.dumps(event, indent=2)}")
            raise e
    else:
        print(f"Bucket {bucket} does not appear to be an origin for a CloudFront distribution")
    return 'Success'


def get_cloudfront_distribution_id(bucket):
    bucket_origin = f"{bucket}.s3.{region}.amazonaws.com"
    cf_distro_id = None
    
    # Create a reusable Paginator
    paginator = cloudfront_client.get_paginator('list_distributions')

    # Create a PageIterator from the Paginator
    page_iterator = paginator.paginate()

    for page in page_iterator:
        for distribution in page['DistributionList']['Items']:
            for cf_origin in distribution['Origins']['Items']:
                    print(f"Origin found {cf_origin['DomainName']}")
                    if bucket_origin == cf_origin['DomainName']:
                            cf_distro_id = distribution['Id']
                            print(f"The CF distribution ID for {bucket} is {cf_distro_id}")
    return cf_distro_id