# Use a base image with Ansible installed
FROM ansible/ubuntu14.04-ansible:stable

# Set up the working directory
WORKDIR /ansible

RUN mkdir -p /workspace/.ansible/tmp && \
    chmod -R 777 /workspace

# Copy the Ansible directory into the container
COPY ansible .

# Default command (optional)
CMD ["ansible-playbook", "--version"]
