##
#
# Dockerfile for our Elastic Search cluster.  The dockerfile is based off of
#  https://github.com/dockerfile/elasticsearch.
#

# Pull base image.
FROM ubuntu:14.04

ENV ES_PKG_NAME elasticsearch-2.1.1

# Install system level packages needed to install elastic search or dependancies.
RUN apt-get -y install software-properties-common

# Install Java.
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 \
    select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Elasticsearch.
RUN \
    cd / && \
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
    tar xvzf $ES_PKG_NAME.tar.gz && \
    rm -f $ES_PKG_NAME.tar.gz && \
    mv /$ES_PKG_NAME /elasticsearch

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300