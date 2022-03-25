FROM jenkins/jenkins:lts
USER root

RUN mkdir -p /tmp/download && \
 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz | tar -xz -C /tmp/download && \
 rm -rf /tmp/download/docker/dockerd && \
 mv /tmp/download/docker/docker* /usr/local/bin/ && \
 rm -rf /tmp/download && \
# works with Ubuntu as host
#  groupadd -g 999 docker && usermod -aG staff,docker jenkins
# works with MacOS as host
 usermod -aG daemon jenkins && touch /var/run/docker.sock && chown root:daemon /var/run/docker.sock && chmod g+w /var/run/docker.sock

# setting passwords (optional)
#RUN echo jenkins:jenkins | chpasswd
#RUN echo root:jenkins | chpasswd

USER jenkins
