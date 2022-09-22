# Jenkins Docker Image Builder
How to create a [Jenkins](https://www.jenkins.io/) image with the docker client installed.

This image is based on the [jenkins/jenkins:lts](https://hub.docker.com/r/jenkins/jenkins) image,
provided and maintained by the [Jenkins Community](https://jenkins.io/).

## Docker Hub Registry

Images created by this repository are available for download from 
[Docker Hub](https://hub.docker.com/repository/docker/marcusveloso/jenkins-docker). 
However, you can build your own images by following the instructions below.

## Prerequisite

These software must be installed on your host machine:
- [Docker](https://www.docker.com/get-started/)
- [GitHub client](https://github.com/git-guides/install-git) (Git comes installed by 
default on most Mac and Linux machines)

## How to Build the Image on Linux or Mac hosts

Clone this GitHub repository using a terminal:
```bash
cd
git clone https://github.com/velosomarcus/jenkins-docker-image-builder.git
cd jenkins-docker-image-builder
```

Before building your own docker image, you will need to configure the _Dockerfile_ file for the host 
(Ubuntu or macOS) where you will run the container by commenting and uncommenting specific lines 20 or 23 
in the file. You can follow the instructions in the _Dockerfile_ itself.

After configuring the _Dockerfile_ for you specific host, run the following commands.

```bash
cd <path-to-jenkins-docker-image-builder-git-clone-folder>
docker build --no-cache -t jenkins-docker:lts .
```

[Optional] Command to see the image created:

```bash
docker images | grep jenkins-docker
```

[Optional] Commands to login, tag and push the created image to your Docker Registry:

```bash
docker tag jenkins-docker:lts <docker-registry>/jenkins-docker:lts
docker login <docker-registry> -u <username>
docker push <docker-registry>/jenkins-docker:lts
```

## How to Start the Jenkins-Docker Container

We cannot install Docker server inside a container running on Docker.
However, if we need to run docker commands inside a container already running
on Docker, we can configure the docker client (installed inside the container) to
have access to the Docker server running on the host. 
This is done by mounting the server's docker socket as a volume inside the docker container.

```bash
# for macOS as host
mkdir -p /Users/marcus/jenkins_home
docker run --name jenkins-docker -d -v /Users/marcus/jenkins_home/:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins-docker:lts
```

```bash
# for Ubuntu as host
mkdir -p /home/ubuntu/jenkins_home
docker run --name jenkins-docker -d -v /home/ubuntu/jenkins_home/:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins-docker:lts
```

## How to Test the Container

The last step is to test whether the Docker client running inside the container can connect to the Docker server
running on the host machine.

Wait until the _jenkins-docker_ container is running and then execute the 
command below on your host machine (Ubuntu or macOS) to connect to the container:

```bash
docker exec -it jenkins-docker bash
```

And then run the command below inside the Jenkins-Docker container:

```bash
docker version
```

If you can see both the client and server versions, you're all set.

Now we can try to access Jenkins server UI. First, we need to get the login token created
during the installation process. To gte the token execute the 
command below on your host machine (Ubuntu or macOS).

```bash
docker logs jenkins-docker bash
```

Then we will see the something like this:

```bash
*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

<our-token-will-be-here>

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************
```

We will use this token to continue the Jenkins installation using a web browser.

- http://<jenkins-host-ip>:8080

Now we can follow the instructions on the [Jenkins Documentation](https://www.jenkins.io/doc/book/installing/docker/) to complete the installation.
