# Jenkins test-pull-requests
#### Jenkins image for use with openshift/test-pull-requests

## Description
This image intergrates test-pull-requests into the openshift jenkins image. This allows a jenkins instance to be deployed to Openshift that is already configured with the necessary tools from openshift/test-pull-requests.

The provided template includes a buildConfig and imageStream to build the jenkins image in the environment. Once built, the deploymentConfig will deploy a jenkins pod using a persistent volume for `/var/lib/jenkins`. The image is built off of the latest openshift-jenkins-2 image.

A disabled `process_pull_requests` job is created that assumes the configuration for the job to be in the container at `/var/lib/jenkins/test_pull_requests_example.json`. The configuration provided is an example and must be changed prior to enabling the job. Once configured, run `test_pull_requests` in an rsh session to the jenkins container to ensure proper functionality.

## Usage
The `jenkins-test-pull-requests-persistent` template builds off of the standard `jenkins-persistent-template`. It provides a buildConfig and imageStream for jenkins-test-pull-requests. Simply deploy the template and a build will be started. Once completed, the deploymentConfig will deploy the image from the imageStream:
```
  $ oc new-app templates/jenkins-test-pull-requests-persistent.json
```

After the build completes and the pod is deployed, navigate in your browser to the route defined for the service. You should be prompted to log in using openshift credentials. Afterwards, the security configuration must be modifed to allow the `test-pull-requests` script to deploy jobs remotely:

As an admin user, navigate to `Manage Jenkins` > `Configure Global Security`. Under `Access Control/Authorization`, select the radio button "Logged-in users can do anything". Save the changes to the settings.

The `process_pull_requests` job will need to be modified to use configuration you provide. An example is in the top-level of this repository. Once a configuration has been created, copy the configuration to the jenkins container (using `oc rsync` or similar). Ensure that the `Execute Shell` instructions of the `process_pull_requests` job points to the configuration file.

Another job will have to be created that will be started when `test-pull-requests` finds a pull request that is ready for testing or merging. The name of the job is specified in cthe configuration and must match the job on the server. A token must also be defined in the configuration that matches the remote execution token for the new job. All jobs executed remotely must have at least one parameter, even if it is not needed due to the way `test-pull-requests` executes jobs.

Lastly, `test-pull-requests` must be run with your configuration on the pod before run through the `process_pull_requests` job. The script will ask for github credentials for the user that will be used to post results to pull requests. `oc rsh` to the jenkins pod and run the script with your configuration specified:
```
$ oc rsh jenkins-test-pull-requests-xxxxx
sh-4.2$ test_pull_requests --config=/var/lib/jenkins/test_pull_requests_example.json
```

See [https://github.com/openshift/test-pull-requests](openshift/test-pull-requests) for more information on how to use the test_pull_requests tool.
