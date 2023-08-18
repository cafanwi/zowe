FROM ubuntu:latest
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y curl nodejs npm openjdk-11-jdk apache2 sudo

# Add a new user named "apacheuser"
RUN useradd -m -s /bin/bash apacheuser

# Set password for apacheuser (Change this to your desired password)
RUN echo 'apacheuser:password' | chpasswd

# Add apacheuser to the sudo group
RUN usermod -aG sudo apacheuser

# Copy the apache.crt file into the image
COPY apache.crt /apache.crt

# Copy the apache.crt file to the system's CA certificates directory
USER root
RUN cp /apache.crt /usr/local/share/ca-certificates/apache.crt && \
    update-ca-certificates

# Configure and start Apache web server
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
