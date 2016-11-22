# jenkins-test-pull-requests
Jenkins image for use with openshift/test-pull-requests

This image intergrates test-pull-requests into the openshift jenkins image. This allows a jenkins instance to be deployed to Openshift that is already configured with the necessary tools from openshift/test-pull-requests.

A disabled `process_pull_requests` job is created that assumes the configuration for the job to be in the container at /var/lib/jenkins/test_pull_requests.json. The configuration is not provided and must be set up prior to enabling the job. Once configured, run `test_pull_requests` in an rsh session to the jenkins container to ensure proper functionality.
