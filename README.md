# Jenkins Docker Image Builder
How to create a Jenkins image with the docker client installed.

## Instructions

To build the docker image you need to configure the Dockerfile for the
host where you will run the image (Ubuntu or macOS) by changing lines
9~12 in this file. After that, run the commands below.
```bash
cd <path-to-jenkins-docker-git-clone-folder>
docker build -t jenkins-docker:lts .
```

To see the image created:
```bash
docker images | grep jenkins-docker
```

[Optional] To log in and push the created image to your Docker Registry:
```bash
docker login <docker-registry> -u <username>
docker push <docker-registry>/jenkins-docker:lts
```

How to start the Jenkins-Docker container with access to the Docker running on host:
```bash
# for macOS as host
mkdir -p /Users/marcus/jenkins_home
docker run --name jenkins-docker -d -v /Users/marcus/jenkins_home/:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins-docker:lts
```

```bash
# for Ubuntu as host
mkdir -p /home/marcus/jenkins_home
docker run --name jenkins-docker -d -v /home/marcus/jenkins_home/:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins-docker:lts
```
