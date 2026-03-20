FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates curl build-essential libssl-dev zlib1g-dev \
    automake autoconf libtool pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --depth=1 https://github.com/TelegramMessenger/MTProxy.git

WORKDIR /opt/MTProxy
RUN make -j"$(nproc)"

WORKDIR /app
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
