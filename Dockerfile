FROM centos:centos7

RUN yum update -y
RUN yum install -y make gcc gcc-c++
RUN yum install -y epel-release
RUN rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum --enablerepo=remi-php55 install -y php

RUN yum install -y httpd
RUN sed -ri 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/meet-geeks\/public"/' /etc/httpd/conf/httpd.conf
RUN sed -ri 's/<Directory "\/var\/www\/html">/<Directory "\/meet-geeks\/public">/' /etc/httpd/conf/httpd.conf
RUN sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

COPY . /meet-geeks
RUN cd /meet-geeks

WORKDIR /meet-geeks

EXPOSE 80

CMD /usr/sbin/httpd -D FOREGROUND
