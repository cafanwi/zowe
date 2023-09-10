# Create, register, and run your own project runner
The iteps involed are:

1. Create a blank project
2. Create a project pipeline.
3. Create and register a project runner.
4. Trigger a pipeline to run your runner.

For More information see link: [create_register_runner](https://docs.gitlab.com/ee/tutorials/create_register_first_runner/)

***Executors***
GitLab Runner implements a number of executors that can be used to run your builds in different environments.
Those executors are:

SSH
Shell
Parallels
VirtualBox
Docker
Docker Autoscaler (experiment)
Docker Machine (auto-scaling)
Kubernetes
Instance (experiment)
Custom

For More information see link: [Executors](https://docs.gitlab.com/runner/executors/#compatibility-chart)

# Tutorial session
- Create a docker image
- Create a gitlab-ci.yml file to build and push image
- register the runner, manually or using a gitlab-ci.yml
- use the registered runner to do a test gradle build

## 1. Create a docker image
- Create a custom docker image that installs gitlab-runner with its dependencies
- see the dockerfile being used to create the custom runner image

```Dockerfile
# Use an image with GitLab Runner pre-installed
FROM gitlab/gitlab-runner:latest

RUN apt-get update && \
    apt-get install -y curl git openjdk-11-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y groovy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV GRADLE_VERSION=7.3.3
RUN curl -LJO "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip "gradle-${GRADLE_VERSION}-bin.zip" -d /opt && \
    rm "gradle-${GRADLE_VERSION}-bin.zip"

# Set Gradle environment variables
ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin

# Install fluxctl
RUN wget https://github.com/fluxcd/flux/releases/download/1.25.4/fluxctl_linux_amd64 -O /usr/local/bin/fluxctl && \
    chmod +x /usr/local/bin/fluxctl

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# # Install Docker
# RUN apt-get update && \
#     apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
#     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
#     apt-get update && \
#     apt-get install -y docker-ce && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*
```

## 2. Create a .gitlab-ci.yml
- Create a .gitlab-ci.yml that builds and pushed the docker image to Artifactory.
- see the .gitlab-ci.yml being used to create the custom runner image

```yaml
stages:
  - build

build_and_push_image:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  variables:
    DOCKER_IMAGE_NAME: "cafanwii/runner-gradle"
    DOCKER_REGISTRY: "docker.io"
    # Add other Docker variables here
  before_script:
    - docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
  script:
    - docker build -t $DOCKER_IMAGE_NAME .
    - docker tag $DOCKER_IMAGE_NAME $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:v1.0.0
    - docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:v1.0.0
  only:
    - main
```

## 3. Register the runner manually or with a gitlab job
- Manually: Simply go to the runner nd get the commands to register runner, and execute on your terminal.
- After the runner is registered, you can [Optionally] check the config.toml file
- The 3 commonly used executors are: [Docker, Shell, Kubernetes]

For this demo, I will be using the ***Kubernetes*** executor:

```yaml
register-runner:
  image: cafanwii/runner-gradle:1.0.0
  script:
    - export KUBECONFIG=$CI_PROJECT_DIR/$KUBECONFIG  # Set the kubeconfig file path
    - gitlab-runner register \
        --non-interactive \
        --executor kubernetes \
        --url https://gitlab.com/ \
        --registration-token 1234567890qwertyuiop \
        --description "My Kubernetes Runner" \
        --tag-list "kubernetes,custom"  # Replace with your desired tags
    - gitlab-runner start
  tags:
    - my-runner  # Optionally, specify tags for the job
  only:
    - main  # Run this job only when changes are pushed to the main branch
```

## 4. Use runner to do a test job

```yaml
build:
  image: cafanwii/runner-gradle:1.0.0
  script:
    - echo "Using Gradle to build the application"
    - # Optionally, configure your environment (e.g., set environment variables)
    - cd /path/to/your/project  # Replace with the actual path to your GitLab project
    - ./gradlew build  # Use the Gradle wrapper script to build your application
  tags:
    - my-runner  # Optionally, specify tags for the job
  only:
    - master  # Run this job only when changes are pushed to the master branch
```


## Deploy image to k8s

## exec into container

## Get the registration token comman for the runner project

## select the right executor to use
- Docker
- Linux
- Kubernetes

### Docker Exedutor
Register the runner using Docker executioner tag: rke --> success

### Kubernetes Exedutor
Register the runner using kubernetes executioner --> NO-success
  - Runner has never contacted this instance

  ACTION: Copy kube/config into container:

```
kubectl cp ~/.kube/config runner-797658d889-mzgk5:/kube   
```

## Create builds using custom runner
- gradle
...

```yaml
stages:
  - build

gradle_build:
  stage: build
  image: your-custom-gitlab-runner-image:latest
  variables:
    GRADLE_OPTS: "-Dorg.gradle.daemon=false"
  script:
    - chmod +x gradlew
    - ./gradlew build
  only:
    - main
```



################ Code #######################

### Dockerfile 1: Dockerfile used to install runner

```Dockerfile
# Use an image with GitLab Runner pre-installed
FROM gitlab/gitlab-runner:latest

RUN apt-get update && \
    apt-get install -y curl git openjdk-11-jdk wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y groovy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV GRADLE_VERSION=7.3.3
RUN curl -LJO "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip "gradle-${GRADLE_VERSION}-bin.zip" -d /opt && \
    rm "gradle-${GRADLE_VERSION}-bin.zip"

# Set Gradle environment variables
ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin

# Install fluxctl
RUN wget https://github.com/fluxcd/flux/releases/download/1.25.4/fluxctl_linux_amd64 -O /usr/local/bin/fluxctl && \
    chmod +x /usr/local/bin/fluxctl

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### yml used 1

```yml
stages:
  - build

build_and_push_image:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  variables:
    DOCKER_IMAGE_NAME: "cafanwii/runner-gradle"
    DOCKER_REGISTRY: "docker.io"
    # Add other Docker variables here
  before_script:
    - docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
  script:
    - docker build -t $DOCKER_IMAGE_NAME .
    - docker tag $DOCKER_IMAGE_NAME $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:v1.0.0
    - docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:v1.0.0
  only:
    - main
```

## Test Docker executors with new builds


***NOTE:*** If your choice is to install girlab manually, you can run commands [Ubuntu]:

```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
apt-get install gitlab-runner
sudo service gitlab-runner status
```