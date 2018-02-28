FROM java:alpine
LABEL Description="Apache JMeter Server"
# Installig Pre-requisite Packages like wget & JRE
RUN apk add --no-cache \ 
    wget \
    telnet \
    iputils-ping \
    unzip

ENV JMETER_VERSION apache-jmeter-4.0
ENV JMETER_PLUGINS JMeterPlugins-ExtrasLibs-1.4.0

# Installing jmeter
RUN mkdir /jmeter \
    && cd /jmeter/ \
    && wget https://archive.apache.org/dist/jmeter/binaries/${JMETER_VERSION}.tgz \
    && tar -xzf ${JMETER_VERSION}.tgz \
    && rm ${JMETER_VERSION}.tgz

RUN mkdir /jmeter-plugins \
    && cd /jmeter-plugins/ \
    && wget https://jmeter-plugins.org/downloads/file/${JMETER_PLUGINS}.zip \
    && unzip -o ${JMETER_PLUGINS}.zip -d /jmeter/${JMETER_VERSION}/

RUN keytool -genkey -keyalg RSA -alias rmi \
    -keystore /jmeter/bin/rmi_keystore.jks \
    -storepass changeit \
    -keypass changeit \
    -keysize 2048 \
    -dname "cn=jmeter-server" 

ENV JMETER_HOME /jmeter/${JMETER_VERSION}/
ENV PATH $JMETER_HOME/bin:$PATH                        

# Ports required for JMeter Slaves/Server
EXPOSE 1099 50000

# Application to be executed to start the JMeter container
ENTRYPOINT jmeter-server \
    -Dserver.rmi.localport=50000 \
    -Dserver_port=1099
