FROM ubuntu:14.04.2
MAINTAINER miurahr@linux.com

ENV PY_VER 3.4.3

RUN env DEBIAN_FRONTEND=noninteractive apt-get update
RUN env DEBIAN_FRONTEND=noninteractiv apt-get -y install \
  build-essential \
  curl \
  libc6-dev libreadline-dev libz-dev libbz2-dev libncursesw5-dev \
  libssl-dev libgdbm-dev libsqlite3-dev liblzma-dev tk-dev

RUN useradd -m ubuntu

USER ubuntu
ENV HOME /home/ubuntu
ENV USER ubuntu

WORKDIR /home/ubuntu

## if you need to compile python from scratch
RUN curl -sL https://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tar.xz  > Python-${PY_VER}.tar.xz && \
    tar xf Python-${PY_VER}.tar.xz && \
    (cd Python-${PY_VER} ; \
    ./configure && make)

RUN mkdir -p ${HOME}/.virtualenvs
RUN (cd Python-${PY_VER}; ./python -m venv ${HOME}/.virtualenvs/py34)

# activate
RUN . ${HOME}/.virtualenvs/py34/bin/activate && \
    pip install ipython

USER root
RUN apt-get clean && apt-get -y autoremove

USER ubuntu

