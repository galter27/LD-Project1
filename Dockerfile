# Use a base image with Ansible installed
FROM cytopia/ansible:latest

# Set up the working directory
WORKDIR /workspace

RUN mkdir -p /workspace/.ansible/tmp && \
    chmod 777 /workspace/.ansible/tmp

# Copy the Ansible directory into the container
COPY ansible /workspace/ansible

# Default command (optional)
CMD ["ansible-playbook", "--version"]
