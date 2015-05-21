FROM centos:centos7

RUN yum update -y
RUN yum install -y ruby ruby-devel make gcc gcc-c++ mysql-devel sqlite-devel
RUN yum install -y epel-release
RUN yum --enablerepo=epel install -y nginx
RUN gem install bundler rake

RUN mkdir -p /var/cache/nginx

RUN rm -rf /etc/nginx
COPY docker/nginx /etc/nginx

COPY . /api_server
RUN cd /api_server && bundle install

EXPOSE 80

WORKDIR /api_server

CMD bundle exec rake db:migrate && bundle exec thin start -C /api_server/config/thin.yml -c /api_server && /usr/sbin/nginx && tail -f /dev/null
