#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND=noninteractive

TERRAFORM_VERSION=0.11.14
TERRAFORM_CHECKSUM=9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd

# Upgrade packages
apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install packages
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    unzip \
    wget

# Install Git & Gitflow toolset
apt-get install -y git-flow

# Install OpenStack command-line client
apt-get install -y python-openstackclient

# Install Terraform
#curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
#    apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
#    apt-get update && \
#    apt-get install -y terraform
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_CHECKSUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform.checksum && \
    sha256sum --strict --check terraform.checksum && \
    unzip -u terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    chmod 0755 /usr/local/bin/terraform && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform.checksum

# Install Ansible
apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge" && \
    apt-get update && \
    apt-get install -y docker-ce && \
    usermod -aG docker ubuntu || true

# Clean
# apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*
