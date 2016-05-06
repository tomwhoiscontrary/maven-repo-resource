#! /bin/bash -eu

cd "$(dirname "$0")"

docker pull alpine:3.3
docker build --tag twic/maven-repo-resource:1 .
