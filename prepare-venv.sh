#!/bin/bash -e
####################################################
# build pyenv developer environment on docker
#
# copyright 2015, Hiroshi Miura <miurahr@linux.com>
#
# It deeply depends on great work by @yyuu,
# please see github.com/yyuu/pyenv in details.
#
# this Dockerifile is licensed by MIT style license.
# see LICENSE for details
#
# project home: github.com/miurahr/docker-pyvenv-dev
#
####################################################
USER=${USER:-py}
HOME=${HOME:-/home/${USER}}

env DEBIAN_FRONTEND=noninteractive apt-get update
env DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
env DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    make build-essential llvm curl git sudo byobu \
    libreadline6 zlib1g libbz2-1.0 libncursesw5 libssl1.0.0 \
    libgdbm3 libdb5.3  libsqlite3-0 liblzma5 libtk8.6 \
    libexpat1 libmpdec2 libffi6 \
    libc6-dev libreadline6-dev zlib1g-dev libbz2-dev libncursesw5-dev \
    libssl-dev libgdbm-dev libdb-dev libsqlite3-dev liblzma-dev tk-dev \
    libexpat1-dev libmpdec-dev libffi-dev \
    mime-support

# create user who can do sudo without password.
useradd -d ${HOME} -m ${USER}
echo "${USER} ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers

exit 0
