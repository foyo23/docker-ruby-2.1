FROM centos:centos7
MAINTAINER foyo23 <foyo23@gmail.com>

ADD install_ruby.sh /tmp/
RUN /tmp/install_ruby.sh

RUN gem update --system --no-document
RUN gem install bundler --no-ri --no-rdoc
