FROM openshift/jenkins-2-centos7

USER root

WORKDIR $JENKINS_HOME

RUN yum install -y ruby && \
    gem install hub rake

RUN git clone https://github.com/openshift/test-pull-requests && \
    mv test-pull-requests/test_pull_requests /usr/local/bin && \
    chmod +x /usr/local/bin/test_pull_requests && \
    mkdir /var/lib/jenkins/merge_queue_records && \
    touch /var/lib/jenkins/test_pull_requests_not_mergeable && \
    rm -rf test-pull-requests

COPY ./jobs/* /var/lib/jenkins/jobs/
COPY test_pull_requests_example.json /var/lib/jenkins/

CMD ["/usr/libexec/s2i/run"]
