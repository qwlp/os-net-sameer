FROM kathara/base:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        isc-dhcp-client \
        isc-dhcp-server \
        tcpdump \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
