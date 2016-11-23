# Jenkins test-pull-requests
#### Jenkins image for use with openshift/test-pull-requests

## Description
This image intergrates test-pull-requests into the openshift jenkins image. This allows a jenkins instance to be deployed to Openshift that is already configured with the necessary tools from openshift/test-pull-requests.

A disabled `process_pull_requests` job is created that assumes the configuration for the job to be in the container at /var/lib/jenkins/test_pull_requests_example.json. The configuration provided is an example and must be changed prior to enabling the job. Once configured, run `test_pull_requests` in an rsh session to the jenkins container to ensure proper functionality.

## Usage
The `jenkins-test-pull-requests-persistent` template builds off of the standard `jenkins-persistent-template`. It provides a buildConfig and imageStream for jenkins-test-pull-requests. Simply deploy the template and a build will be started. Once completed, the deploymentConfig will deploy the image from the imageStream:
```
  $ oc new-app templates/jenkins-test-pull-requests-persistent.json
```

See [https://github.com/openshift/test-pull-requests](openshift/test-pull-requests) for more information on how to use the test_pull_requests tool.
