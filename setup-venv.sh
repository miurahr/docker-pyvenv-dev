#!/bin/bash
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
set -e
DEVELOPER=pyuser
DEVELOPER_HOME=/home/${DEVELOPER}

# part1: install pytnon versions and cleanup

# Environment variable for building
#
# if PY_VERS is not empty, it build all of python versions.
#  and set PY_VER as default.
#
#  only PY_VER defined, it build with python with PY_VER
#  no varialble defined, it set default as follows:
PY_VER=${PY_VER:-3.4.3}

if [ "${PY_VERS}" == "" ]; then
  echo "setup pyenv with Python ${PY_VER}."
else
  echo "setup pyenv with Python versions: ${PY_VERS}."
  echo "default version is ${PY_VER}."
fi

env DEBIAN_FRONTEND=noninteractive apt-get update
env DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
env DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    make build-essential llvm curl git sudo \
    libreadline6 zlib1g libbz2-1.0 libncursesw5 libssl1.0.0 \
    libgdbm3 libdb5.3  libsqlite3-0 liblzma5 libtk8.6 \
    libexpat1 libmpdec2 libffi6 \
    libc6-dev libreadline6-dev zlib1g-dev libbz2-dev libncursesw5-dev \
    libssl-dev libgdbm-dev libdb-dev libsqlite3-dev liblzma-dev tk-dev \
    libexpat1-dev libmpdec-dev libffi-dev \
    mime-support

## user setup
useradd -m ${DEVELOPER}
echo "${DEVELOPER} ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers

PYENV_ROOT=${DEVELOPER_HOME}/.pyenv
cd ${DEVELOPER_HOME}

function run_as_user () {
  sudo -u ${DEVELOPER} -E -H env PATH=${PATH} $*
}

function append_bashrc () {
  FILE=${DEVELOPER_HOME}/.bashrc
  echo $* |sudo -u ${DEVELOPER} tee -a $FILE
}

function install_python_version () {
  local ver=$1

  run_as_user pyenv install $ver
  run_as_user pyenv rehash
  run_as_user pyenv global  $ver
  run_as_user pip install -U pip
}

## pyenv setup
run_as_user git clone --quiet --depth 1 https://github.com/yyuu/pyenv.git ${PYENV_ROOT}
append_bashrc "export PYENV_ROOT=${PYENV_ROOT}"
append_bashrc "export PATH=${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
append_bashrc 'eval "$(pyenv init -)"'

## pyenv-virtualenv plugin
run_as_user git clone --quiet --depth 1 https://github.com/yyuu/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv

## install python
if [ "${PY_VERS}" == "" ]; then
  # single version install
  install_python_version ${PY_VER}
else
  for v in ${PY_VERS} ; do
    install_python_version $v
  done
fi

## clean up
env DEBIAN_FRONTEND=noninteractive apt-get -y remove \
    libc6-dev libreadline6-dev zlib1g-dev libbz2-dev libncursesw5-dev \
    libssl-dev libgdbm-dev libdb-dev libsqlite3-dev liblzma-dev tk-dev \
    libexpat1-dev libmpdec-dev libffi-dev
env DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
env DEBIAN_FRONTEND=noninteractive apt-get clean

exit 0
