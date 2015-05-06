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
FROM ubuntu:14.04.2
MAINTAINER miurahr@linux.com

ENV PY_VERS 3.4.3 2.7.9 pypy3-2.4.0 pypy-2.5.0
ENV PY_VER 3.4.3
COPY setup-venv.sh /tmp/
RUN chmod +x /tmp/setup-venv.sh
RUN /tmp/setup-venv.sh

RUN apt-get -q -y install byobu && apt-get clean

USER pyuser
ENV HOME /home/pyuser
ENV USER pyuser
ENV PYENV_ROOT ${HOME}/.pyenv
WORKDIR /home/pyuser
RUN mkdir -p ${HOME}/workspace && \
    byobu-launcher-install -n

VOLUME ["${HOME}/workspace"]
ENTRYPOINT ["/bin/bash"]

## now you can run here by 'docker run -it miurahr/pyvenv'
## It automatically launch shell and byobu.
## Please don't forget add '-it'(interactive/terminal) argument option.
## Docker will enter guest environment as non-login session.
