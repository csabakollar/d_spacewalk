FROM centos:6
MAINTAINER Csaba Kollar <csaba.kollar@gmail.com>
LABEL description="Spacewalk 2.4"

ADD files/jpackage.repo /etc/yum.repos.d/jpackage.repo
RUN rpm -Uvh http://yum.spacewalkproject.org/2.4/RHEL/6/x86_64/spacewalk-repo-2.4-3.el6.noarch.rpm
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

RUN yum install -y supervisor spacewalk-setup-postgresql spacewalk-postgresql spacewalk-utils wget perl-Text-Unidecode perl-XML-Simple

RUN wget -O /tmp/errata-import.tar http://cefs.steve-meier.de/errata-import.tar 
RUN tar -xf /tmp/errata-import.tar -C /opt 
ADD files/answers /opt 
ADD files/spacewalk.sh /opt
ADD files/spacewalk.conf /etc/supervisor-spacewalk.conf
RUN chmod +x /opt/spacewalk*

EXPOSE 80 443 5222 5269
VOLUME /var/satellite /var/lib/cobbler /root/ssl-build /var/lib/rhn
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor-spacewalk.conf"]
