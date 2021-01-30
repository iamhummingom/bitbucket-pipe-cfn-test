# Bitbucket Pipelines Pipe: cfn-test
This project creates a docker for bitbucket pipe, which can be used to test AWS cloudformation template. 
[taskcat](https://github.com/aws-quickstart/taskcat?trk=ia-button) is used here for lint and test execution.
This pipe is for bitbucket deployment step.
```  
- step:
      <<: *test
      name: test
      deployment: tst
```

## YAML Definition
Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
- pipe: docker://iamhummingom/bitbucket-pipe-cfn-test:0.1.0
  variables:
    AWS_ACCESS_KEY_ID: '<string>' # Required 
    AWS_SECRET_ACCESS_KEY: '<string>' # Required
    AWS_DEFAULT_REGION: '<string>' # Required
    TEMPLATE: '<string>'

    # BITBUCKET variables - available during step deployment
    # BITBUCKET_REPO_SLUG: '<string>'
    # BITBUCKET_DEPLOYMENT_ENVIRONMENT: '<string>'

```

## Variables
The following variables are required:

| Variable | Usage |
| ----------- | ----- |
| AWS_ACCESS_KEY_ID (*)                | AWS access key. |
| AWS_SECRET_ACCESS_KEY (*)            | AWS secret key. |
| AWS_DEFAULT_REGION (*)               | The AWS region code (us-east-1, us-west-2, etc.) of the region containing the AWS resource(s). For more information, see [Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html) in the _Amazon Web Services General Reference_. |
| TEMPLATE (*)                          | Filename of aws cloudformation yml. example : infra.yml |
| BITBUCKET_REPO_SLUG (**)               | The operation to perform. Valid options are 'update' or 'alias'. |
| BITBUCKET_DEPLOYMENT_ENVIRONMENT (**)  | Path to the zip file containing the function code. Required for 'update' |

_(*) = required variable. This variable needs to be specified always when using the pipe._
_(**) = required variable. While using in bitbucket pipe, these will be automatically set while using step deployment. For local test, these needs to be set locally._

## Details
### Lint and Test AWS Cloudformation scripts
The pipe will install taskcat and run ```taskcat lint``` and ```taskcat test run```. Also creation of taskcat configuration file .taskcat.yml is done here.

## Prerequisites
For testing AWS infra, you will need:

  * A Cloudformation script
  * An IAM user configured with programmatic access that can perform resource creation in AWS.

## Task Output
The pipe will write taskcat logs in pipeline console.

## Examples
### Test a Cloudformation script
Test Cloudformation script 'infra.yml' in region 'eu-west-1'.
```yaml
script:
  - pipe: docker://iamhummingom/bitbucket-pipe-cfn-test:0.1.0
    variables:
      AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
      AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION
      TEMPLATE: 'infra.yml'
```

## Test locally
In Docker file if you copy to a location (cfn-test), and if you have infra.yml in the current path, then with the below command you can test locally.
```-v /var/run/docker.sock:/var/run/docker.sock``` is needed for ```dind``` as taskcat needs docker service.
```
docker build --tag cfn-test -f Dockerfile .
docker run --rm --name cfn-test -v "%CD%":/cfn-test -v /var/run/docker.sock:/var/run/docker.sock --env-file ./env.list cfn-test
```
