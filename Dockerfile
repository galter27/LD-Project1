# Use a base image with Ansible installed
FROM cytopia/ansible:latest

# Set up the working directory
WORKDIR /ansible

RUN mkdir -p /workspace/.ansible/tmp && \
    chmod 777 /workspace/.ansible/tmp

# Copy the Ansible directory into the container
COPY ansible/* .

# Default command (optional)
CMD ["ansible-playbook", "--version"]
