FROM frolvlad/alpine-java:jdk8-slim
LABEL Description="Apache JMeter Server"
RUN apk update \
    && apk add wget unzip

ENV JMETER_VERSION apache-jmeter-5.1.1

# Installing jmeter
RUN mkdir /jmeter \
    && cd /jmeter/ \
    && wget https://archive.apache.org/dist/jmeter/binaries/${JMETER_VERSION}.tgz \
    && tar -xzf ${JMETER_VERSION}.tgz \
    && rm ${JMETER_VERSION}.tgz

ENV JMETER_HOME /jmeter/${JMETER_VERSION}/
ENV PATH $JMETER_HOME/bin:$PATH

# Ports required for JMeter Slaves/Server
EXPOSE 1099 50000

WORKDIR ${JMETER_HOME}/bin
# Application to be executed to start the JMeter container
ENTRYPOINT jmeter-server \
    -Dserver.rmi.ssl.disable=true \
    -Dserver.rmi.localport=50000 \
    -Dserver_port=1099
