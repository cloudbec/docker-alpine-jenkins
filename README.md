nuagebec/alpine-jenkins:play-1.2
================

Uses the Alpine image and sets up a container with [Jenkins](http://jenkins-ci.org/) installed.

Just intended to a small master image to avoid bloated containers. Mostly intended to leverage other containers as slaves.

# Our Slave List

Imagine a list of links here that go to other docker container repo that have really specific and interesting purposes!

# Build Info

## Plugins
* greenballs:latest
* token-macro:latest
* run-condition:latest
* envinject:latest
* conditional-buildstep:latest
* durable-task:latest
* jquery:latest
* aws-java-sdk:latest
* copyartifact:latest
* compress-artifacts:latest
* copy-to-slave:latest
* ssh:latest
* slave-status:latest
* ansicolor:latest
* antisamy-markup-formatter:latest
* build-pipeline-plugin:latest
* chef:latest
* chef-identity:latest
* credentials:latest
* git:latest
* gitbucket:latest
* git-changelog:latest
* git-client:latest
* ghprb:latest
* gravatar:latest
* jenkins-multijob-plugin:latest
* matrix-auth:latest
* matrix-project:latest
* matrix-reloaded:latest
* pam-auth:latest
* parameterized-trigger:latest
* plain-credentials:latest
* ruby-runtime:latest
* run-condition:latest
* scm-api:latest
* ssh-credentials:latest
* ssh-slaves:latest
* s3:latest
* disk-usage:latest
* embeddable-build-status:latest
* docker-plugin:latest
* sbt:latest
* play-autotest-plugin:latest

## Ports
* Jenkins: 8080 Container Side
* Slaves: 50000 Container Side

## Installed Packages
* gnupg
* tar
* git
* zip
* curl
* wget

# Usage

```
docker run -p 8080:8080 -p 50000:50000  nuagebec/alpine-jenkins:play-1.2
```

This will store the workspace in /var/lib/jenkins. All Jenkins data lives in there - including plugins and configuration.
You will probably want to make that a persistent volume (recommended):

```
docker run -p 8080:8080 -p 50000:50000 -v /your/home:/var/lib/jenkins nuagebec/alpine-jenkins
```

You can also use a volume container:

```
docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/lib/jenkins nuagebec/alpine-jenkins
```

# Building

To build the image, do the following:

```
% docker build nuagebec/alpine-jenkins:play-1.2
```

A prebuilt container is available in the docker index.

```
% docker pull nuagebec/alpine-jenkins:play-1.2
```

# Web configuration

 Manage Jenkins > Configure System

 JDK :
 1.7 JAVA_HOME=/usr/lib/jvm/java-1.7-openjdk/
 1.7 JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/

 Play:
 PLAY_HOME=/opt/play/play-1.2.7.2/
