Goal is to use an Ubuntu-based Docker image with GitLab Runner installed and use that image as our CI/CD runner in GitLab. 

1. Create a Dockerfile:

```Dockerfile
FROM ubuntu:latest

# Install dependencies and GitLab Runner
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash && \
    apt-get install -y gitlab-runner && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Register the runner (replace with your GitLab Runner registration command)
RUN gitlab-runner register --non-interactive \
    --url "https://gitlab.example.com/" \
    --registration-token "REGISTRATION_TOKEN" \
    --executor "docker" \
    #--executor "shell" \
    --name "hogan-custom-runner" \
    --tag-list "dev" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

# Entrypoint
ENTRYPOINT ["gitlab-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
```

2. Configure .gitlab-ci.yml in the GitLab CI/CD project to use the custom runner image.

```yaml
image: artifactory-gitlab-5000/test-runner:latest

stages:
  - build
  - test

build_job:
  stage: build
  script:
    - echo "Building..."

test_job:
  stage: test
  script:
    - echo "Testing..."
```

Register the Runner:
You only need to register the runner once when creating the Docker image, as shown in the Dockerfile. The registration is part of the image creation process.

Run Your Pipeline:
Push your code changes to GitLab to trigger your CI/CD pipeline. The custom runner image will be used to execute the jobs defined in your .gitlab-ci.yml file.


docker run -d --name gitlab-runner \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /path/to/config:/etc/gitlab-runner \
  cafanwii/gitlabrunner-gitlabjob:1.0.1 register \
    --non-interactive \
    --url https://gitlab.com/ \
    --registration-token GR1348941_RV_j6Fm1-Dv8bp9zEdX \
    --executor docker \
    --docker-image cafanwii/gitlabrunner-gitlabjob:1.0.1

docker run -d -p 4444:4444 -v /dev/shm:/dev/shm cafanwii/ubuntu-chrome-with-index:1.0.1
