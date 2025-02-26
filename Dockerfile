# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jre

LABEL version="0.11.5"

RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD=" Server Powered by Docker"
ENV LEVEL=world
ENV JVM_OPTS="-Xms2048m -Xmx4096m"

