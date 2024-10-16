#!/usr/bin/env sh

docker build --no-cache --platform linux/amd64 -t code2code-docker.pkg.coding.net/puupees/k8s/postgresql-backup-restore:latest -f Dockerfile .
docker push code2code-docker.pkg.coding.net/puupees/k8s/postgresql-backup-restore:latest