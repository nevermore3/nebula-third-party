FROM centos:8
SHELL ["/bin/bash", "-c"]

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y epel-release yum-utils &&  yum config-manager --set-enabled powertools && yum update -y \
 && yum install -y make \
                   git \
                   m4 \
                   curl \
                   wget \
                   unzip \
                   which \
                   xz \
                   patch \
                   python3 \
                   python3-devel \
                   redhat-lsb-core \
                   perl-Data-Dumper \
                   perl-Thread-Queue \
                   readline-devel \
                   ncurses-devel \
                   zlib-devel \
                   gcc \
                   gcc-c++ \
                   libtool \
                   autoconf \
                   autoconf-archive \
                   automake \
                   bison \
                   flex \
                   gperf \
                   gettext \
   && yum --enablerepo=powertools install -y ninja-build \
   && yum clean all && rm -rf /var/cache/yum

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-linux-$(uname -m).sh \
    && chmod +x cmake-3.20.0-linux-$(uname -m).sh \
    && ./cmake-3.20.0-linux-$(uname -m).sh --skip-license --prefix=/usr/local \
    && rm cmake-3.20.0-linux-$(uname -m).sh

# Install libdwarf-20200114
RUN wget --no-check-certificate https://www.prevanders.net/libdwarf-20200114.tar.gz \
    && tar -xzf libdwarf-20200114.tar.gz \
    && cd libdwarf-20200114 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf libdwarf-20200114 libdwarf-20200114.tar.gz

# Install ossutil
RUN curl https://gosspublic.alicdn.com/ossutil/install.sh | bash

# Install MinIO Client
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        curl -O https://dl.min.io/client/mc/release/linux-arm64/mc; \
    else \
        curl -O https://dl.min.io/client/mc/release/linux-amd64/mc; \
    fi \
    && chmod +x mc \
    && mv mc /usr/local/bin

ENV PACKAGE_DIR=/usr/src/third-party    
RUN mkdir -p ${PACKAGE_DIR}
WORKDIR ${PACKAGE_DIR}

