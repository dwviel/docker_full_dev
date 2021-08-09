FROM ubuntu:18.04

LABEL maintainer="Lei Mao <dukeleimao@gmail.com>"
# ref: https://medium.com/cubemail88/c-dev-and-debug-with-docker-containers-c89b851a4b69

# Install necessary dependencies
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        automake \
        libtool \
        pkg-config \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        wget \
        git \
        curl \
        gnupg \
        zlib1g-dev \
        swig \
        vim \
        gdb \
        emacs \
        x11-apps \
        valgrind \
        locales \
        locales-all \
        xauth \
        openssh-server &&\
    apt-get clean


# ref : https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393#file-dockerfile-L5
RUN apt update \
    && sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_


# Install CMake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - &&\
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ bionic main" &&\
    apt-get update &&\
    apt-get install -y cmake

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DISPLAY :0

# Add user for ssh and give sudo rights
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 fulldev
# Set users password 
RUN  echo 'fulldev:fulldev' | chpasswd
# Run SSH server
RUN service ssh start
# Expose the sshd port
EXPOSE 22
# Run the sshd service
CMD ["/usr/sbin/sshd","-D"]
