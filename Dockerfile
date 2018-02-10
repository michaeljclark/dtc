FROM centos:7
RUN yum update -y && yum install -y \
  bison \
  flex \
  gcc \
  rsync \
  rpm-build \
  make
WORKDIR /usr/src/app
