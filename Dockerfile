FROM openshift/jenkins-2-centos7

USER root

WORKDIR $JENKINS_HOME

RUN yum install -y ruby && \
    gem install hub rake

RUN git clone https://github.com/openshift/test-pull-requests && \
    mv test-pull-requests/test_pull_requests /usr/bin && \
    chmod +x /usr/bin/test_pull_requests && \
    touch /opt/openshift/configuration/merge_queue_records && \
    touch /opt/openshift/configuration/test_pull_requests_not_mergeable && \
    rm -rf test-pull-requests

RUN mkdir /opt/openshift/configuration/jobs/process_pull_requests

COPY jobs/process_pull_requests/ /opt/openshift/configuration/jobs/process_pull_requests/
COPY test_pull_requests_example.json /opt/openshift/configuration/

CMD ["/usr/libexec/s2i/run"]
