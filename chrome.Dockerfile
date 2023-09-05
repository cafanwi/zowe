# # Use an official Python runtime as a parent image
# FROM python:3.9

# # Set environment variables to prevent Python from writing bytecode and to ensure output is sent to the terminal without buffering
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # Install Git, Chrome dependencies, and Chrome WebDriver
# RUN apt-get update && apt-get install -y \
#     git \
#     wget \
#     unzip \
#     curl \
#     xvfb \
#     libxi6 \
#     libgconf-2-4 \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # Download and install Google Chrome dependencies
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# RUN sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# RUN apt-get update && apt-get install -y google-chrome-stable

# # Install Chrome WebDriver (ensure you get the appropriate version)
# RUN wget -q https://chromedriver.storage.googleapis.com/91.0.4472.101/chromedriver_linux64.zip
# RUN unzip chromedriver_linux64.zip -d /usr/local/bin/
# RUN rm chromedriver_linux64.zip

# # Create a directory for your Selenium scripts
# WORKDIR /app

# # Install any Python dependencies for your Selenium script
# COPY requirements.txt /app/
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy your Selenium script into the container
# COPY cafanwii_selenium_script.py /app/

# # Command to run your Selenium script
# CMD ["python", "cafanwii_selenium_script.py"]
