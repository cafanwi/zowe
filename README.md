Licenced to: CAFANWI

https://www.zowe.org/learn
https://docs.zowe.org/stable/user-guide/installandconfig/
https://docs.zowe.org/stable/extend/packaging-zos-extensions/


## Zowe consists of the following components:
Zowe Application Framework
API Mediation Layer
Zowe CLI
Zowe Explorer
Zowe Client Software Development Kits SDKs
Zowe Launcher
ZEBRA (Zowe Embedded Browser for RMF/SMF and APIs) - Incubator

***Focus:*** Zowe CLI

## System requirements

1. Client-side requirements
Node.js: Install a currently supported version of Node.js LTS.

use the script [nodejs.sh]

```
chmod +x nodejs.sh
sh nodejs.sh
```

Get more info about installation: [System requirements](https://docs.zowe.org/stable/user-guide/systemrequirements-cli/)

```
node --version
npm --version
```

2. Server-side requirements

Zowe CLI requires the following mainframe configuration:
  - IBM z/OSMF configured and running: 
  - Plug-in services configured and running:
  - Zowe CLI on z/OS is not supported: 

Get more info about installation: [System requirements](https://docs.zowe.org/stable/user-guide/systemrequirements-cli/)

## NEXT: Configuring Secure Credential Store on headless Linux operating systems
See Link: [https://docs.zowe.org/stable/user-guide/cli-configure-scs-on-headless-linux-os/](https://docs.zowe.org/stable/user-guide/cli-configure-scs-on-headless-linux-os/)

### Unlocking the keyring automatically
***Note:*** The following steps were tested on CentOS, SUSE, and Ubuntu operating systems. The steps do not work on WSL (Windows Subsystem for Linux) because it bypasses TTY login.

***STEPS:***

1. Install the PAM module for [libpam-gnome-keyring:] for Debian, Ubuntu:

```
vi /etc/pam.d/login
```

- Add the following statement to the end of the auth section:

```sh
auth optional pam_gnome_keyring.so
```

- Add the following statement to end of the session section:

```sh
session optional pam_gnome_keyring.so auto_start
```

- Add the following commands to ~/.bashrc:

```py
if [[ $- == *i* ]]; then  # Only run in interactive mode
  if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    exec dbus-run-session -- $SHELL
  fi

  gnome-keyring-daemon --start --components=secrets
fi
```

- Restart your computer:

```
sudo reboot
```

***NOTE:*** If trying to Configure Zowe CLI on operating systems where the Secure Credential Store is not available:

See this Link to guide you with Implementing: [https://docs.zowe.org/stable/user-guide/cli-configure-cli-on-os-where-scs-unavailable](https://docs.zowe.org/stable/user-guide/cli-configure-cli-on-os-where-scs-unavailable)

### Install Zowe CLI from npm
Follow this Link: [Install Zowe CLI from npm](https://docs.zowe.org/stable/user-guide/cli-installcli/#install-zowe-cli-from-npm)

Prerequisite notes:

```
sudo npm install -g prebuild-install
```

You will see a message like this:


***THIS IS JUST OUTPUT, NOT NOTE***

> ubuntu@ip-172-31-253-82:~/zowe$ sudo npm install -g prebuild-install
> /usr/bin/prebuild-install -> /usr/lib/node_modules/prebuild-install/bin.js + prebuild-install@7.1.1
> added 37 packages from 34 contributors in 2.307s

***NOW,*** Install @zowe/cli:

```
npm install -g @zowe/cli@zowe-v2-lts
```

***NOTE: If you face issues, then Do the Following:***

1. 
Change npm's default directory where global npm packages are installed.
This will prevent the need for elevated privileges when installing global packages.

Type thie 2 commands to your uubuntu terminal 

```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
```

2. 
Add .bashrc or .bash_profile file (located in your home directory) to ensure that the newly configured npm directory is in your PATH:

```bash
export PATH=~/.npm-global/bin:$PATH
```

If Zowe CLI is Installed, Get the Zowe Version:

```
zowe --version
```

***OPTIONALLY***: You can clear your cache with command:

```
npm cache clean --force
```

***NOW,*** Install the Zowe Plugin:

```
zowe plugins install @zowe/cics-for-zowe-cli@zowe-v2-lts @zowe/db2-for-zowe-cli@zowe-v2-lts @zowe/ims-for-zowe-cli@zowe-v2-lts @zowe/mq-for-zowe-cli@zowe-v2-lts @zowe/zos-ftp-for-zowe-cli@zowe-v2-lts
```

***NOOOOOOOOO!***: Only this plugin installed so far:

> Installed plugin name = '@zowe/cics-for-zowe-cli'
> _____ Validation results for plugin '@zowe/cics-for-zowe-cli' _____
> This plugin was successfully validated. Enjoy the plugin.


List the installed plugins:

```
zowe plugins list
```

## Docker Implementation
- Build a Dockerfile

```Dockerfile
FROM ubuntu:latest # Use Ubuntu as the base image

ENV DEBIAN_FRONTEND=noninteractive   # Set environment variables

RUN apt-get update && apt-get install -y \    # Install required dependencies
    curl \
    nodejs \
    npm

RUN npm install -g @zowe/cli && \      # Install Zowe CLI and plugins
    zowe plugins install @zowe/cics-for-zowe-cli@zowe-v2-lts @zowe/db2-for-zowe-cli@zowe-v2-lts @zowe/ims-for-zowe-cli@zowe-v2-lts @zowe/mq-for-zowe-cli@zowe-v2-lts @zowe/zos-ftp-for-zowe-cli@zowe-v2-lts

CMD ["/bin/bash"]
```


- Build the Docker image, run the container

```
docker build -t cafanwi/zowe:1.0.0 .
docker run -it cafanwi/zowe:1.0.0
```

enter the shell:

```
docker run -it cafanwi/zowe:1.0.0
```

run test commands:

```
zowe --version
zowe plugins list
```


***NEXT:*** Authenticate with Zowe:
Before using the Zowe CLI to interact with mainframe resources, you need to authenticate with Zowe. The specific authentication process will depend on the configuration set up by your mainframe administrator. Commonly, you can use the following command to authenticate:

```
zowe profiles create mfhost --host <hostname> --user <username> --pass <password>
```

 After creating the profile, you can switch to it using:

```
zowe profiles switch mfhost
```

OPTIONAL: Working with Data Sets:

```
zowe files list datasets
zowe files browse data-set "your.dataset.name"
zowe files download data-set "your.dataset.name" --dest /path/to/local/directory
zowe files upload file /path/to/local/file "your.dataset.name(member)"
```

Working with Mainframe Jobs (JCL):


```
zowe jobs submit local-file /path/to/your/jclfile.jcl
```

Using Zowe CLI Plugins:

```
zowe cics --help
```

## Write a Gitlab Pipeline stage to connect to mainframe. I have 2 mainframe dummy examples:

```yml
stages:
  - connect_to_mainframe

connect_to_mainframe_1:
  stage: connect_to_mainframe
  image: my_zowe_image
  script:
    - zowe profiles create mfhost1 --host 10.0.0.1 --user macazcol1 --pass "Depay20$"
    - zowe profiles switch mfhost1
    # Add more Zowe CLI commands to interact with mainframe 1

connect_to_mainframe_2:
  stage: connect_to_mainframe
  image: my_zowe_image
  script:
    - zowe profiles create mfhost2 --host 10.0.0.21 --user macazcol2 --pass "Depay21$"
    - zowe profiles switch mfhost2
    # Add more Zowe CLI commands to interact with mainframe 2
```

```yml
# Define the stages that will be executed in the CI/CD pipeline.
stages:
  - build
  - test
  - deploy

# Job to build the Groovy project
build_groovy:
  stage: build
  image: groovy:latest
  script:
    - groovy --version  # Display Groovy version
    # Add any other build commands for the Groovy project here

# Job to build the Java project
build_java:
  stage: build
  image: maven:latest
  script:
    - mvn --version  # Display Maven version
    # Add any other build commands for the Java project here

# Job to run tests for both projects
test:
  stage: test
  image: openjdk:latest
  script:
    - groovy --version  # Display Groovy version
    - mvn --version  # Display Maven version
    # Add any other test commands for both projects here

# Job to deploy to production
deploy_to_production:
  stage: deploy
  image: ubuntu:latest  # Replace with the appropriate Docker image for your production environment
  script:
    # Add deployment commands here, such as copying files to the production server or using deployment tools
    # Example:
    - scp groovy-app.jar user@production-server:/path/to/deploy

# Define the deployment environment
production:
  stage: deploy
  script:
    # Add any post-deployment commands or checks here (e.g., smoke tests, status checks)

# Specify when the deployment should be executed
# For simplicity, we trigger deployment only after manual approval
# You can use other triggers, such as on a specific branch or tag
only:
  - master  # Deploy only on the master branch
  - triggers  # Deploy when manually triggered
```
