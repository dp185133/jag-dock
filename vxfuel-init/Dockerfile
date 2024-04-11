#DockerFile

FROM alpine:3.19.1


#Copy script to tail googlelog.json
COPY start.sh /usr/local/bin

WORKDIR /usr/local/bin

#Start default app
ENTRYPOINT ["/usr/local/bin/start.sh"]