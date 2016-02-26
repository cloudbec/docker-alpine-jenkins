#! /bin/bash

# Parse a support-core plugin -style txt file as specification for jenkins plugins to be installed
# in the reference directory, so user can define a derived Docker image with just :
#
# FROM jenkins
# COPY plugins.txt /plugins.txt
# RUN /usr/local/bin/plugins.sh /plugins.txt
#

set -e

REF=$JENKINS_SHARE/ref/plugins
mkdir -p $REF
pluginsToInstall=

# enforce plugin format
while read spec || [ -n "$spec" ]; do
    plugin=(${spec//:/ });
    [[ ${plugin[0]} =~ ^# ]] && continue
    [[ ${plugin[0]} =~ ^\s*$ ]] && continue
    [[ -z ${plugin[1]} ]] && plugin[1]="latest"

    pluginsToInstall+=(${plugin[0]})

done  < $1
echo "Install these plugins : "
echo ${pluginsToInstall[@]}

if [ !  ${#pluginsToInstall[@]}  -eq 0  ] ; then
    echo test
    /usr/local/bin/jenkins & \
        until
            $(curl --output /dev/null --silent --head --fail http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar);
        do
            printf '.';   sleep 5;
        done && \
            wget http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar && \
            sleep 5 && \
            java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin ${pluginsToInstall[@]}  && \
            curl -X POST http://127.0.0.1:8080/exit && \
            while pgrep java > /dev/null; do printf '.'; sleep 1; done && \
            mv $JENKINS_HOME/plugins $REF

fi
