FROM python:3.7.4-slim-buster

# arm-gcc + other tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    srecord \
    libncurses5-dev \
    libc6-i386 \
    wget \
    make \
    sshpass \
    bzip2 \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget -q https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2 && \
    tar -xf gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2
ENV PATH "$PATH:/opt/gcc-arm-none-eabi-5_4-2016q3/bin"

# Protobuf
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    libtool \
    curl \
    g++ \
    unzip \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp
RUN curl -OLs https://github.com/google/protobuf/releases/download/v3.10.0/protoc-3.10.0-linux-x86_64.zip
RUN unzip -q protoc-3.10.0-linux-x86_64.zip -d protobuf
RUN mv /tmp/protobuf/bin/protoc /usr/local/bin/
RUN mv /tmp/protobuf/include/* /usr/local/include/

# Protobuf-python
WORKDIR /tmp
RUN curl -OLs https://github.com/google/protobuf/releases/download/v3.10.0/protobuf-python-3.10.0.zip && \
    unzip -q protobuf-python-3.10.0.zip -d protobuf-python
WORKDIR /tmp/protobuf-python/protobuf-3.10.0/python
RUN python setup.py build && \
    python setup.py test && \
    python setup.py install

# Print versions
RUN arm-none-eabi-gcc --version && \
    gcc --version && \
    python --version && \
    protoc --version && \
    make --version
