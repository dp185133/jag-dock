#DockerFile

FROM alpine:3.19.1


#Copy script to tail googlelog.json
RUN mkdir -p /usr/local/bin
COPY start.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/start.sh

WORKDIR /usr/local/bin

RUN adduser -D -u 701 pcrfuel
USER pcrfuel

#Start default app
ENTRYPOINT ["/usr/local/bin/start.sh"]
# ENTRYPOINT ["/bin/sh"]
# CMD ["-c", "tail", "-F", "/dev/null"]

