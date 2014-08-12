#!/bin/bash -ex

export RUBY_INSTALL_VERSION=0.4.3
export RUBY_VERSION=2.1.2

cd /tmp

yum list installed | cut -f 1 -d " " | uniq | sort > /tmp/pre
yum install bzip2 git tar wget -y

wget http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm && \
    rpm -ivh epel-release-7-0.2.noarch.rpm && \
    yum -y update && \
    yum -y install sudo nginx git-core python zlib-devel \
       readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel \
       byacc gcc-c++ libyaml-devel libffi-devel libxml2-devel libxslt-devel libicu-devel system-config-firewall-tui \
       python-devel make cmake bison libodb-mysql-devel patch libtool libicu-devel && \
    gem install --no-ri --no-rdoc bundler && \
    yum clean all

wget -O ruby-install-$RUBY_INSTALL_VERSION.tar.gz \
  https://github.com/postmodern/ruby-install/archive/v$RUBY_INSTALL_VERSION.tar.gz
tar -xzf ruby-install-$RUBY_INSTALL_VERSION.tar.gz
cd ruby-install-$RUBY_INSTALL_VERSION
make install
ruby-install -i /usr/local ruby $RUBY_VERSION

make uninstall
yum list installed | cut -f 1 -d " " | uniq | sort > /tmp/post
diff /tmp/pre /tmp/post | grep "^>" | cut -f 2 -d ' ' | xargs echo yum erase -y
yum clean all
rm -rf /usr/local/src/ruby*
rm -rf /tmp/*
