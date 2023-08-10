## ci pipeline

```
stages:
  - deploy

deploy_to_kubernetes:
  stage: deploy
  image:
    name: lachlanevenson/k8s-kubectl:v1.21.0
    entrypoint: [""]
  script:
    - echo "$KUBECONFIG" > kubeconfig.yaml
    - kubectl apply -f my-pod.yaml --kubeconfig=kubeconfig.yaml
  variables:
    KUBECONFIG: "$KUBECONFIG_CONTENT"  # Add your kubeconfig content as a CI/CD variable
  only:
    - main

```

Dockerfile

```
# Use a base image that includes kubectl
FROM bitnami/kubectl:latest

# Install Helm
ENV HELM_VERSION="3.6.3"
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version $HELM_VERSION && \
    rm get_helm.sh

# Set the working directory
WORKDIR /app

# Copy any files you need into the container
COPY deployment.yaml .
COPY service.yaml .

```
