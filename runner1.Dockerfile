# Use Ubuntu as the base image
FROM ubuntu:latest

# Install dependencies and GitLab Runner
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash && \
    apt-get install -y gitlab-runner && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the registration token as an environment variable
ENV REGISTRATION_TOKEN="YOUR_REGISTRATION_TOKEN"

# Register the runner (replace with your GitLab Runner registration command)
RUN gitlab-runner register --non-interactive \
    --url "https://gitlab.example.com/" \
    --registration-token "$REGISTRATION_TOKEN" \
    --executor "docker" \ # Use Docker executor
    --name "my-custom-runner" \
    --tag-list "my-tag" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"

# Entrypoint
ENTRYPOINT ["gitlab-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
