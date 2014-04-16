###### Jenkins image
# runs jenkins instance within a container
FROM qnib/fd20
MAINTAINER "Christian Kniep <christian@qnib.org>"

##### USER
# Set (very simple) password for root
RUN echo "root:root"|chpasswd

# Solution for 'ping: icmp open socket: Operation not permitted'
RUN chmod u+s /usr/bin/ping
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime 


RUN yum install java-1.7.0-openjdk
RUN curl -o /usr/share/jenkins-1.532.3.war  http://ftp.nluug.nl/programming/jenkins/war-stable-rc/1.532.3/jenkins.war

CMD /bin/supervisord
