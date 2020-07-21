FROM ubuntu:18.04

MAINTAINER ameen <ameennagiwale@gmail.com>

USER root

# Prerequisites
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget curl net-tools coreutils bash rsync  tar sudo  openssh-client rsync apt-utils

#RUN apt-get clean && apt-get update && apt-get install -y locales
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    locales-all 

RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64 
ENV PATH $PATH:$JAVA_HOME/bin

ENV SPARK_VER 2.3.1

ENV LIVY_VERSION 0.6.0-incubating

ENV LIVY_PORT 8998

ENV PYTHON_VERSION 3.7

ENV LIVY_URL https://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip

ENV LIVY_HOME /livy





RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VER/spark-$SPARK_VER-bin-hadoop2.7.tgz && \
	tar -xvf spark-$SPARK_VER-bin-hadoop2.7.tgz -C /usr/local && \
	rm spark-$SPARK_VER-bin-hadoop2.7.tgz

RUN ln -s /usr/local/spark-$SPARK_VER-bin-hadoop2.7 /usr/local/spark

ENV SPARK_HOME /usr/local/spark

ADD config/* /usr/local/hadoop/etc/hadoop/

ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop

ENV PATH $PATH:$SPARK_HOME/bin


COPY start-livy.sh /

RUN ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

RUN apt-get update
RUN apt-get install unzip
RUN rm -rf /var/cache/apk/*
        
RUN   wget -c $LIVY_URL -O /tmp/livy-bin.zip \
      && unzip /tmp/livy-bin.zip -d /tmp/ \
      && mv /tmp/apache-livy-${LIVY_VERSION}-bin ${LIVY_HOME} \
      && rm /tmp/livy-bin.zip \
      && cp ${LIVY_HOME}/conf/livy.conf.template ${LIVY_HOME}/conf/livy.conf \ 
      && cp ${LIVY_HOME}/conf/log4j.properties.template ${LIVY_HOME}/conf/log4j.properties 

# Copy config file
COPY livy.conf $LIVY_HOME/conf
COPY livy-env.sh $LIVY_HOME/conf
        
EXPOSE ${LIVY_PORT}


ADD bootstrap.sh /etc/bootstrap.sh

CMD bash /start-livy.sh

WORKDIR /usr/local/spark

CMD ["/etc/bootstrap.sh"]
