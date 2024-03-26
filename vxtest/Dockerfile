FROM ubuntu:22.04 as base

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

# mostly for dev 
RUN apt-get install -y tini
RUN apt-get install -y net-tools curl netcat

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/usr/bin/tail", "-F", "/dev/null"]

