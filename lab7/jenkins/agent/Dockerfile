FROM jenkins/inbound-agent:latest

USER root

# Встановлення інструментів для збірки
RUN apt-get update && apt-get install -y \
    build-essential \
    rpm \
    shellcheck \
    && rm -rf /var/lib/apt/lists/*

USER jenkins
