FROM eboraas/debian:jessie
MAINTAINER miurahr@linux.com

ENV PY3_VER 3.4.3
ENV PY2_VER 2.7.9

## dependencies 
RUN env DEBIAN_FRONTEND=noninteractive apt-get update
RUN env DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
RUN env DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
  build-essential curl git \
  libc6-dev libreadline6-dev zlib1g-dev libbz2-dev libncursesw5-dev \
  libssl-dev libgdbm-dev libdb-dev libsqlite3-dev liblzma-dev tk-dev \
  libexpat1-dev libmpdec-dev libffi-dev mime-support locales-all
RUN env DEBIAN_FRONTEND=noninteractive apt-get clean

## user setup
RUN useradd -G sudo -m pyuser
USER pyuser
ENV HOME /home/pyuser
ENV USER pyuser
WORKDIR /home/pyuser
RUN mkdir -p ${HOME}/workspace

## pyenv setup
RUN git clone --quiet --depth 1 https://github.com/yyuu/pyenv.git ${HOME}/.pyenv
ENV PATH ${HOME}/.pyenv/shims:${HOME}/.pyenv/bin:${PATH}
ENV PYENV_ROOT ${HOME}/.pyenv
RUN echo 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc

## install python2/3
RUN pyenv install ${PY3_VER}
RUN pyenv install ${PY2_VER}
RUN pyenv rehash

## docker configuration
USER pyuser
VOLUME ["${HOME}/workspace"]
ENTRYPOINT ["/bin/bash"]
