https://services.gradle.org/distributions/

https://docs.gitlab.com/ee/tutorials/configure_gitlab_runner_to_use_gke/


This Dockerfile installs OpenJDK 11 (Java) alongside the existing installations. What will be installed:
Java, GitLab Runner, Groovy, and Gradle --> all set up in your Docker image, making it suitable for running Gradle builds in your GitLab CI/CD pipeline.


this yaml will be used for the gradle builds

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
