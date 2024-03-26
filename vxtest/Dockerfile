FROM i386/ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

# mostly for dev 
RUN apt-get install -y net-tools curl telnet


ENTRYPOINT ["tail", "-f", "/dev/null"]

CMD ["/bin/bash", ":0"]

