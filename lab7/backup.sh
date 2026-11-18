#!/bin/bash

BACKUP_DIR="$HOME/jenkins-backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$BACKUP_DIR"

docker run --rm \
    -v lab7_jenkins_home:/data:ro \
    -v "$BACKUP_DIR":/backup \
    ubuntu:latest \
    tar -czf "/backup/jenkins-$DATE.tar.gz" -C /data .

echo "Backup created: jenkins-$DATE.tar.gz"
