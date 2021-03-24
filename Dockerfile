FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install -y gcc build-essential gettext ncdu git jq man wget curl screen pv xz-utils unzip vim-nox openssh-server iputils-ping \
                    sudo make cmake pkg-config flex mtd-utils texinfo bison gawk bc automake scons net-tools cpio rpm2cpio kmod \
                    libglib2.0-dev libglib2.0-bin transfig libncurses5-dev libmysqlclient-dev python-dev ruby ruby-dev p7zip exuberant-ctags cscope \
                    qemu libacl1-dev libssl-dev uuid-dev uuid zlib1g-dev gcc-multilib g++-multilib yasm nasm libtool autoconf autogen mingw-w64

RUN echo 'root:root' | chpasswd
RUN sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config


RUN rm -rf /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian/ jessie main" | sudo tee -a /etc/apt/sources.list
RUN echo "deb-src http://archive.debian.org/debian/ jessie main" | sudo tee -a /etc/apt/sources.list
RUN echo "Acquire::Check-Valid-Until false;" | sudo tee -a /etc/apt/apt.conf.d/10-nocheckvalid
RUN echo 'Package: *\nPin: origin "archive.debian.org"\nPin-Priority: 500' | sudo tee -a /etc/apt/preferences.d/10-archive-pin
RUN sudo apt-get update
RUN sudo dpkg --configure -a
RUN sudo apt-get install -y --allow-unauthenticated libacl1-dev libssl-dev uuid-dev uuid
RUN sudo apt-get install -y --allow-unauthenticated zlib1g-dev gcc-multilib g++-multilib
RUN sudo apt-get install -y --allow-unauthenticated yasm nasm
RUN sudo apt-get install -y --allow-unauthenticated build-essential
RUN sudo apt-get install -y --allow-unauthenticated libtool automake autoconf autogen
RUN sudo apt-get install -y --allow-unauthenticated mingw-w64

CMD ["/usr/sbin/sshd", "-D"]

ENV HOME /root
WORKDIR /root
