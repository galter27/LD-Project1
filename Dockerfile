# Use a base image with Ansible installed
FROM devture/ansible:latest

# Install useradd
RUN apk add --no-cache shadow && \
    useradd -ms /bin/bash ubuntu && \
    mkdir -p /workspace && \
    chown -R ubuntu:ubuntu /workspace

# Set up the working directory
WORKDIR /ansible

RUN mkdir -p /workspace/.ansible/tmp && \
    chmod -R 777 /workspace

# Copy the Ansible directory into the container
COPY ansible .

# Default command (optional)
CMD ["ansible-playbook", "--version"]
