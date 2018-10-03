FROM debian:buster-slim

ENV HOME /bitcoincash

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV BCH_VERSION=1.10.0

RUN groupadd -g ${GROUP_ID} bitcoincash \
  && useradd -u ${USER_ID} -g bitcoincash -s /bin/bash -m -d /bitcoincash bitcoincash \
  && apt-get update && apt-get install -y gnupg \
  && set -x \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 74FBA0B99748FAADE065B23111057DDDF08490BA && \
  echo "deb http://ppa.launchpad.net/bitcoin-abc/ppa/ubuntu bionic main" > /etc/apt/sources.list.d/bitcoin-abc.list && \
  apt-get update && apt-get install -y --no-install-recommends \
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