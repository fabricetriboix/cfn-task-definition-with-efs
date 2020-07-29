CloudFormation custom resource: Task definition with EFS
========================================================

This project implements a CloudFormation custom resource Lambda
backend to register a task definition with EFS mounts.

How to install the Lambda function?
-----------------------------------

Create an IAM policy using the `task-definition-lambda-policy.json`
file. For example with the AWS command line tool:

```bash
$ aws --profile YOUR_PROFILE iam create-policy \
        --policy-name task-definition-lambda-policy \
        --policy-document file://./task-definition-lambda-policy.json
```

Make a note of the policy ARN. Then create an IAM role for the Lambda
function using the above policy, and name it
`task-definition-lambda-role`. For example with the AWS command line
tool:

```bash
$ aws --profile YOUR_PROFILE iam create-role \
        --role-name task-definition-lambda-role \
        --assume-role-policy-document file://./task-definition-role-assume-policy.json
$ aws --profile YOUR_PROFILE iam attach-role-policy \
        --role-name task-definition-lambda-role \
        --policy-arn ARN_OF_PREVIOUSLY_CREATE_POLICY
```

Make a note of the role ARN. Finally, create the Lambda function thus:

```bash
$ ./package.sh
$ aws --profile YOUR_PROFILE lambda create-function \
        --function-name task-definition \
        --memory 128 \
        --timeout 30 \
        --role ARN_OF_PREVIOUSLY_CREATE_ROLE \
        --runtime python3.6 \
        --zip-file fileb://./task_definition.zip \
        --handler task_definition.handler
```

How to use the `task-definition` custom resource?
-------------------------------------------------

Checkout the [cfn-test.yml](cfn-test.yml) file for an example of a
working CloudFormation template.

In essence, just use the parameters as described in the
[`RegisterTaskDefinition` AWS
API](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_RegisterTaskDefinition.html).

If you want to use the `cfn-test.yml` file, you will need to build and
upload the [timestamp-app](timestamp-app) Docker image. In order to do
that, you will need to edit the
[timestamp-app/Dockerfile](timestamp-app/Dockerfile) file to use your
Docker hub account.

You can verify it's working by launching an EC2 instance in the same
subnet you selected when deploying the CloudFormation template and
mounting the EFS filesystem thus:

```bash
$ sudo mkdir /efs
$ sudo mount -t nfs4 EFSID.efs.REGION.amazonaws.com:/ /efs
```

EFSID is the ID of the EFS filesystem, which is shown as an output of
the CloudFormation template.
