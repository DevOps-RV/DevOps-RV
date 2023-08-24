# Lambda function to create CloudFront invalidations for updated objects in S3

This Lambda function listens to S3 object create and update events and creates CloudFront invalidations for the updated objects. This ensures that the updated objects are served from the CloudFront cache instead of the S3 origin.

## Prerequisites

- AWS account
- IAM role with permissions to create and manage Lambda functions, S3 buckets, and CloudFront distributions
- Python 3.8 or later
- Boto3 library

## Installation

1. Clone the repository to your local machine.
2. Install the required dependencies using pip: `python3 -m pip install -r requirements.txt -t .`.
3. Zip the contents of the repository: `zip -r function.zip .`
4. Upload the zip file to your Lambda function.

## Configuration

1. Create an S3 bucket and upload your content to it.
2. Create a CloudFront distribution with the S3 bucket as the origin.
3. Create a Lambda function with the following configuration:
   - **Runtime:** Python 3.8 or later
   - **Handler:** `app.lambda_handler`
   - **Environment variables:**
     - `AWS_REGION`: The AWS region where your resources are located
   - **Execution role:** The IAM role with following permissions to create and manage resources
     - policy permissions: "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents","cloudfront:CreateInvalidation"
4. Create s3 Event notifications to trigger Lambda function
   - **Trigger:** S3 bucket with object create and update events

## Usage

When an object is created or updated in the S3 bucket, the Lambda function will create a CloudFront invalidation for the updated object. The invalidation will ensure that the updated object is served from the CloudFront cache instead of the S3 origin.

### Author: Raghu Vamsi

#### 🔗 Links
[![Linkedin](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/devops-rv/)](https://www.linkedin.com/in/devops-rv/)
[![Medium](https://img.shields.io/badge/-Medium-000000?style=flat&labelColor=000000&logo=Medium&link=https://medium.com/@DevOps-Rv)](https://medium.com/@DevOps-Rv)
