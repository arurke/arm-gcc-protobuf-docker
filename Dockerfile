FROM python:2.7.15

# arm-gcc + other tools
RUN apt-get update && apt-get install -y srecord libncurses5-dev libc6-i386 wget make sshpass
WORKDIR /opt
RUN wget -q https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2 && \
    tar -xf gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2
ENV PATH "$PATH:/opt/gcc-arm-none-eabi-5_4-2016q3/bin"

# Protobuf
RUN apt-get install -y autoconf automake libtool curl g++ unzip
WORKDIR /tmp
RUN curl -OLs https://github.com/google/protobuf/releases/download/v3.1.0/protoc-3.1.0-linux-x86_64.zip
RUN unzip -q protoc-3.1.0-linux-x86_64.zip -d protobuf
RUN mv /tmp/protobuf/bin/protoc /usr/local/bin/
RUN mv /tmp/protobuf/include/* /usr/local/include/

# Protobuf-python
WORKDIR /tmp
RUN curl -OLs https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-python-3.1.0.zip && \
    unzip -q protobuf-python-3.1.0.zip -d protobuf-python
WORKDIR /tmp/protobuf-python/protobuf-3.1.0/python
RUN python setup.py build && \
    python setup.py test && \
    python setup.py install

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN arm-none-eabi-gcc --version && gcc --version && python --version && protoc --version && make --version
