#!/bin/bash


docker build . -t quay.io/jparrill/kube-burner-stress-tools:latest --push
docker build --platform linux/amd64 . -t quay.io/jparrill/kube-burner-stress-tools:latest --push
