FROM jenkins/jenkins:lts
USER root

RUN apt update && \
 apt install procps -y && \
 apt install sudo -y && \
 apt install python3 python3-pip -y && \
 apt install ansible -y && \
 usermod -aG sudo jenkins && \
 echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN python3 -m pip install awscli
RUN mkdir -p /tmp/download && \
 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz | tar -xz -C /tmp/download && \
 rm -rf /tmp/download/docker/dockerd && \
 mv /tmp/download/docker/docker* /usr/local/bin/ && \
 rm -rf /tmp/download && \
## When using Ubuntu as a host machine, make sure you get the correct docker group ID on your host
## we can get that ID (1001?) by running this command on the Ubuntu host machine: getent group docker
## uncomment line below when building the image to run with Ubuntu as host
 groupadd -g 1001 docker && usermod -aG staff,docker jenkins
## When using macOS as a host machine, the docker socket file is associated with the daemon group and we don't need the docker group ID.
## uncomment line below when building the image to run with macOS as host
# usermod -aG daemon jenkins && touch /var/run/docker.sock && chown root:daemon /var/run/docker.sock && chmod g+w /var/run/docker.sock

# Attention: Make sure you only have line 12 OR line 15 uncommented. You can't have both or neither lines uncommented.

# setting passwords (optional)
#RUN echo jenkins:jenkins | chpasswd
#RUN echo root:jenkins | chpasswd

USER jenkins
