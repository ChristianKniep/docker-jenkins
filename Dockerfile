###### Jenkins image
# runs jenkins instance within a container
FROM qnib/fd20
MAINTAINER "Christian Kniep <christian@qnib.org>"

# Solution for 'ping: icmp open socket: Operation not permitted'
RUN chmod u+s /usr/bin/ping
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime 

RUN yum clean all
RUN yum install -y java-1.7.0-openjdk
RUN curl -s -o /usr/share/jenkins.war  http://ftp.nluug.nl/programming/jenkins/war/1.574/jenkins.war

RUN yum install -y supervisor
RUN sed -i -e 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

# SSH keys to log into git-server without a password
ADD root/ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
ADD root/ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 644 /root/.ssh/id_rsa.pub
ADD root/ssh/known_hosts /root/.ssh/known_hosts
RUN chmod 644 /root/.ssh/known_hosts

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
#RUN gem install --source http://rubygems.org fpm
# RUN yum install -y rubygem-fpm
### \WORKAROUND

### Jenkins HOME
RUN mkdir -p /opt/jenkins
#ADD ./jenkins /opt/jenkins
ADD etc/supervisord.d /etc/supervisord.d

CMD /bin/supervisord -c /etc/supervisord.conf
