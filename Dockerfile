FROM centos:5
# Must use an old enough image 
# to ensure binaries built by pyinstaller
# could run on most of the distributions

MAINTAINER tgic <farmer1992@gmail.com>


# Build Python 2.7.9 from source

RUN yum install -y curl gcc make openssl-devel

RUN set -ex; \
    curl -LO https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz; \
    tar -xzf Python-2.7.9.tgz; \
    cd Python-2.7.9; \
    ./configure --enable-shared; \
    make; \
    make install; \
    cd ..; \
    rm -rf /Python-2.7.9; \
    rm Python-2.7.9.tgz

# Make libpython findable
ENV LD_LIBRARY_PATH /usr/local/lib

# Install setuptools
RUN set -ex; \
    curl -LO https://bootstrap.pypa.io/ez_setup.py; \
    python ez_setup.py; \
    rm ez_setup.py

# Install pip
RUN set -ex; \
    curl -LO https://pypi.python.org/packages/source/p/pip/pip-7.0.1.tar.gz; \
    tar -xzf pip-7.0.1.tar.gz; \
    cd pip-7.0.1; \
    python setup.py install; \
    cd ..; \
    rm -rf pip-7.0.1; \
    rm pip-7.0.1.tar.gz

RUN pip install pyinstaller


VOLUME /code/

RUN useradd -d /code -m -s /bin/bash user
WORKDIR /code/
RUN chown -R user /code/

USER user

ENTRYPOINT /usr/local/bin/pyinstaller
