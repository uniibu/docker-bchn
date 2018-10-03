FROM debian:buster-slim

ENV HOME /bitcoincash

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV BCH_VERSION=1.10.0

RUN groupadd -g ${GROUP_ID} bitcoincash \
  && useradd -u ${USER_ID} -g bitcoincash -s /bin/bash -m -d /bitcoincash bitcoincash \
  && apt-get update -y \
  && apt-get install -y software-properties-common \
  && set -x \
  && add-apt-repository ppa:bitcoin-abc/ppa \
  && apt-get update -y && apt-get install -y --no-install-recommends \
  curl gosu bitcoinabc \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/bch_oneshot

VOLUME ["/bitcoincash"]

EXPOSE 8432 8433

WORKDIR /bitcoincash

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bch_oneshot"]