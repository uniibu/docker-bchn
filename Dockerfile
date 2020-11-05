FROM bitsler/wallet-base:focal

ENV HOME /bitcoincash

ENV USER_ID 1000
ENV GROUP_ID 1000

RUN groupadd -g ${GROUP_ID} bitcoincash \
  && useradd -u ${USER_ID} -g bitcoincash -s /bin/bash -m -d /bitcoincash bitcoincash \
  && set -x \
  && apt-get update -y \
  && apt-get install -y curl gosu \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG version=22.1.0
ENV BCH_VERSION=$version

RUN curl -sL https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases/download/v${BCH_VERSION}/bitcoin-cash-node-${BCH_VERSION}-x86_64-linux-gnu.tar.gz | tar xz --strip-components=1 -C /usr/local --exclude=*-qt


ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/bch_oneshot

VOLUME ["/bitcoincash"]

EXPOSE 8432 8433

WORKDIR /bitcoincash

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bch_oneshot"]
