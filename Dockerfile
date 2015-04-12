###### Jenkins image
# runs jenkins instance within a container
FROM qnib/terminal:cos7
MAINTAINER "Christian Kniep <christian@qnib.org>"

RUN yum clean all
RUN yum install -y java-1.8.0-openjdk
RUN cd /usr/share/ && wget -q http://mirrors.jenkins-ci.org/war/1.608/jenkins.war

##### Provide tools to do stuff
# grok testing
RUN yum install -y python-docopt python-simplejson python-envoy rubygems
### WORKAROUND
RUN yum install -y ruby-devel make gcc
#RUN gem install jls-grok
#RUN yum install rubygem-jls-grok 
#### \WORKAROUND
# fpm and git
RUN yum install -y git-core rpm-build createrepo bc
### WORKAROUND
RUN gem install --source http://rubygems.org fpm
# RUN yum install -y rubygem-fpm
### \WORKAROUND

### Jenkins HOME
RUN mkdir -p /opt/jenkins
#ADD ./jenkins /opt/jenkins
ADD etc/supervisord.d/jenkins.ini /etc/supervisord.d/
ADD etc/consul.d/check_jenkins.json /etc/consul.d/check_jenkins.json

## To pip install pyslurm
RUN pip install --upgrade pip && \
    pip install cython
