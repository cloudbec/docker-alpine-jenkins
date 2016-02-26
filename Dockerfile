FROM cloudbec/openjdk

MAINTAINER Michael Faille "michael@faille.io"

# Environment Variables
ENV JENKINS_VERSION 1.642.2
ENV JENKINS_HOME /var/lib/jenkins
ENV JENKINS_SHARE /usr/share/jenkins
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JENKINS_UC https://updates.jenkins-ci.org
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

RUN apk update
RUN apk --no-cache add \
    gnupg \
    tar \
    ruby \
    git \
    zip \
    curl \
    wget \
    bash \
    fontconfig \
    ttf-dejavu

# Add jenkins user
RUN addgroup jenkins && \
    adduser -h $JENKINS_HOME -D -s /bin/bash -G jenkins jenkins

# Setup directories and rights so Jenkins user can do things without sudo
COPY systemconfig.sh /tmp/systemconfig.sh
RUN bash -c /tmp/systemconfig.sh

# Pull LTS version of Jenkins listed above
RUN curl -fL http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o $JENKINS_SHARE/jenkins.war

# Setup plugin update command
COPY plugins.sh /usr/local/bin/plugins

# Volumes
VOLUME $JENKINS_HOME

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

RUN mkdir -p /opt/play-1.2 && wget --progress=bar:force:noscroll  https://downloads.typesafe.com/play/1.2.7.2/play-1.2.7.2.zip -O play-1.2.zip && unzip play-1.2.zip -d /opt/play-1.2 && rm play-1.2.zip

## Downgrade user to install the rest
USER jenkins

# Copy additional files needed from repo into container
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY jenkins.sh /usr/local/bin/jenkins


# Install a plugins using script above
WORKDIR $JENKINS_HOME
COPY plugins.txt $JENKINS_SHARE/plugins.txt
# RUN /usr/local/bin/plugins $JENKINS_SHARE/plugins.txt
RUN /usr/local/bin/jenkins & \
    until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar); do   printf '.';   sleep 5; done && \
    wget http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar && \
    sleep 5 && \
    java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin $(cut -d ":" -f 1 $JENKINS_SHARE/plugins.txt ) && \
    curl http://127.0.0.1:8080/exit && \
    mv plugins   $JENKINS_SHARE/ref/.


RUN ls -la $JENKINS_SHARE/ref

# /usr/local/bin/jenkins

# "/usr/local/bin/jenkins
ENTRYPOINT ["/usr/local/bin/jenkins"]
