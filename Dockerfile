#
# Dockerfile to use for common ngs analyses.
#
# --------------------------------------------------------------


# meta
# ----
FROM ubuntu:xenial
MAINTAINER Blake Printy "bprinty@gmail.com"


# install
# -------
# installing apt-get deps
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    bc \
    bzip2 \
    curl \
    emacs24 \
    gcc \
    less \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libffi-dev \
    libjpeg-dev \
    liblzma-dev \
    libncurses5-dev \
    libssl-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    locales \
    make \
    make \
    man \
    openssh-server \
    perl \
    rsync \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    zlib1g-dev


# install conda
RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/install-conda.sh && \
    /bin/bash /tmp/install-conda.sh -b -p /usr/local -u && \
    rm -rf /tmp/install-conda.sh

# install python
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get update
RUN apt-get install -y \
    python3.5 \
    python3.5-dev \
    python3-pip
RUN ln -sf /usr/bin/python3.5 /usr/bin/python
RUN ln -sf /usr/bin/pip3 /usr/bin/pip

# install pip
RUN pip install -U pip==10.0.1
RUN pip install \
    setuptools \
    ipython

# install htslib
ENV HTSLIB_VERSION 1.3.2
RUN cd /tmp && \
    wget https://github.com/samtools/htslib/releases/download/$HTSLIB_VERSION/htslib-$HTSLIB_VERSION.tar.bz2 -O /tmp/htslib.tar.bz2 && \
    tar -xjvf htslib.tar.bz2 && \
    cd htslib-$HTSLIB_VERSION && \
    make install

# install samtools
ENV SAMTOOLS_VERSION 1.3.1
RUN cd /tmp && \
    wget https://github.com/samtools/samtools/releases/download/$SAMTOOLS_VERSION/samtools-$SAMTOOLS_VERSION.tar.bz2 -O /tmp/samtools.tar.bz2 && \
    tar -xjvf samtools.tar.bz2 && \
    cd samtools-$SAMTOOLS_VERSION && \
    make -j HTSDIR=/tmp/htslib-$HTSLIB_VERSION && \
    make install

# install bwa
ENV BWA_VERSION 0.7.17
RUN cd /tmp && \
    wget https://github.com/lh3/bwa/releases/download/v$BWA_VERSION/bwa-$BWA_VERSION.tar.bz2 -O /tmp/bwa.tar.bz2 && \
    tar -xjvf bwa.tar.bz2 && \
    cd bwa-$BWA_VERSION && \
    make && \
    install -m 0755 bwa /usr/local/bin/

# install crossmap
ENV CROSSMAP_VERSION 0.5.2
RUN pip install CrossMap==$CROSSMAP_VERSION

# clean apt cache
RUN apt-get clean


# locale
# ------
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# run
# ---
WORKDIR /home
CMD ["/bin/bash"]
