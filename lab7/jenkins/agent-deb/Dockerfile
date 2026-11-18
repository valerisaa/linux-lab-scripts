FROM jenkins/inbound-agent:latest

USER root

# Встановлення інструментів для DEB-пакетів
RUN apt-get update && apt-get install -y \
    build-essential \
    dpkg-dev \
    debhelper \
    devscripts \
    && rm -rf /var/lib/apt/lists/*

USER jenkins
