FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt -y upgrade && apt -y install wget && apt clean && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/unifi-video.gpg.key http://www.ubnt.com/downloads/unifi-video/apt-3.x/unifi-video.gpg.key
RUN apt-key add /tmp/unifi-video.gpg.key
RUN sh -c "echo \"deb [arch=amd64] http://www.ubnt.com/downloads/unifi-video/apt-3.x xenial ubiquiti\" > /etc/apt/sources.list.d/unifi-video.list"

RUN apt update && apt -y install unifi-video && apt clean && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb
RUN dpkg -i dumb-init_*.deb

RUN sed -i 's/ulimit/#ulimit/' /usr/sbin/unifi-video
RUN sed -i 's/ENABLE_TMPFS=yes/ENABLE_TMPFS=no/g' /usr/sbin/unifi-video

EXPOSE 6666/tcp 7004/udp 7080/tcp 7443/tcp 7445/tcp 7446/tcp 7447/tcp
VOLUME ["/var/lib/mongodb", "/var/lib/unifi-video", "/var/log/unifi-video"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/usr/sbin/unifi-video", "--nodetach", "--debug", "start" ]
