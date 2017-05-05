#FROM armhf/debian:jessie
FROM resin/armv7hf-debian-qemu:latest
# Default configuration
RUN [ "cross-build-start" ]

COPY requirements_all.txt /tmp/
#COPY libcec /tmp/

RUN set -ex \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	python3 python3-pip python3-dev \
	libssl-dev git nmap build-essential \
        pkg-config \
        libboost-python-dev libboost-thread-dev libbluetooth-dev>=4.101 libglib2.0-dev \
        python3-cryptography \
#        cmake libudev-dev libxrandr-dev swig \
# && cd /tmp/ \
# && /tmp/libcec \
# && git clone https://github.com/Pulse-Eight/platform.git \
# && mkdir platform/build \
# && cd platform/build \
# && cmake .. \
# && make \
# && sudo make install \
# && cd /tmp/ \
# && git clone https://github.com/Pulse-Eight/libcec.git \
# && mkdir libcec/build \
# && cd libcec/build \
# && cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib .. \
# && make -j4
# && make install
# && ldconfig
 && pip3 install -r /tmp/requirements_all.txt \
 && pip3 install homeassistant \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

# && apt-get purge --auto-remove -y \
#	build-essential \
    # Limited access rights.

# Add Tini
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /tini
RUN chmod +x /tini

RUN useradd -ms /bin/bash hass
RUN [ "cross-build-end" ]
# Run as mopidy user
USER hass

EXPOSE 8123

ENTRYPOINT ["/tini", "--"]

VOLUME /config

CMD ["/usr/bin/hass -c /config"]
