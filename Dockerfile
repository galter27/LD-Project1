# Base image
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip sshpass && \
    pip3 install ansible

# Copy the ansible directory from the repository
COPY ansible /ansible

# Set the working directory to the copied ansible directory
WORKDIR /ansible