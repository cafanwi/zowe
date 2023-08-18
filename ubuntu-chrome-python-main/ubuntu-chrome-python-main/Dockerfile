# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y curl git openjdk-11-jdk unzip wget curl lynx iproute2 python3 python3-pip gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Git
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Google Chrome repository key
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Set up Google Chrome repository
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Install Google Chrome
RUN apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install xdg-utils
RUN apt-get update && \
    apt-get install -y xdg-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Groovy
RUN apt-get update && \
    apt-get install -y groovy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dumb-init
RUN curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/bin/dumb-init

# Create a user named "hogandevops"
#RUN useradd -ms /bin/bash hogandevops

# Install Gradle 8.2.1
ENV GRADLE_VERSION=8.2.1
RUN curl -LJO "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip "gradle-${GRADLE_VERSION}-bin.zip" -d /opt && \
    rm "gradle-${GRADLE_VERSION}-bin.zip"

# Set Gradle environment variables
ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin

# Install Python packages
RUN pip3 install selenium flask

# [OPTIONAL]Copy the index.html file into the image
COPY index.html /index.html

# Set the entry point
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Set the default user
#USER hogandevops

# Set the default command for the container
CMD ["/bin/bash"]
