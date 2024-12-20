#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update package index
apt-get update -y

# Install required dependencies
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
apt-get update -y

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation
docker --version

# Download Docker Compose binary
DOCKER_COMPOSE_VERSION="v2.22.0"
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the Docker Compose binary
chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
docker-compose --version

# Enable and start Docker service
systemctl enable docker
systemctl start docker

# Add current user to the Docker group (optional)
read -p "Do you want to add the current user to the Docker group? (y/n): " add_user
echo
if [ "$add_user" == "y" ] || [ "$add_user" == "Y" ]; then
  usermod -aG docker $(whoami)
  echo "User added to the Docker group. Please log out and log back in for the changes to take effect."
fi

echo "Docker and Docker Compose have been installed successfully!"
