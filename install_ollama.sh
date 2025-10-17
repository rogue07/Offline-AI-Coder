#!/bin/bash

# Ollama + Open WebUI Installation Script for Debian 13
# Installs Ollama, Qwen2.5-Coder:7b model, and Open WebUI

set -e  # Exit on error

echo "=========================================="
echo "Ollama + Qwen2.5-Coder + Web UI Installer"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please don't run this script as root/sudo"
   echo "The installer will ask for sudo when needed"
   exit 1
fi

# Update package list
echo "Updating package list..."
sudo apt update

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y curl ca-certificates gnupg lsb-release

# Remove any old Docker packages
echo "Removing old Docker packages if present..."
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Add Docker's official GPG key
echo "Adding Docker repository..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list with new repo
echo "Updating package list..."
sudo apt update

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# Enable and start Docker
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Test Docker installation
echo "Testing Docker installation..."
if ! sudo docker run --rm hello-world > /dev/null 2>&1; then
    echo "ERROR: Docker installation failed!"
    exit 1
fi

echo "Docker installed successfully!"

# Install Ollama
echo ""
echo "Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

# Wait for installation to complete
sleep 2

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "ERROR: Ollama installation failed!"
    exit 1
fi

echo ""
echo "Ollama installed successfully!"

# Configure Ollama to listen on all interfaces
echo ""
echo "Configuring Ollama to be accessible from Docker..."
sudo mkdir -p /etc/systemd/system/ollama.service.d
echo -e "[Service]\nEnvironment=\"OLLAMA_HOST=0.0.0.0:11434\"" | sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null

# Reload systemd and restart Ollama
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl restart ollama

# Wait for service to start
sleep 3

# Verify Ollama is running
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "ERROR: Ollama service failed to start!"
    exit 1
fi

# Pull the Qwen2.5-Coder model
echo ""
echo "Downloading Qwen2.5-Coder:7b model..."
echo "This may take several minutes (model is ~4.7GB)..."
ollama pull qwen2.5-coder:7b

# Stop existing container if it exists
echo ""
echo "Cleaning up any existing Open WebUI container..."
sudo docker stop open-webui 2>/dev/null || true
sudo docker rm open-webui 2>/dev/null || true

# Install Open WebUI using Docker with proper network configuration
echo ""
echo "Installing Open WebUI (Web Frontend)..."
echo "This may take a few minutes..."

# Get host IP for Docker to connect to Ollama
HOST_IP=$(ip route get 1 | awk '{print $7;exit}')

# Run Open WebUI container
sudo docker run -d \
  --name open-webui \
  --network host \
  --restart always \
  -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main

# Wait for container to start
echo "Waiting for Open WebUI to start..."
sleep 15

# Check if container is running
if sudo docker ps | grep -q "open-webui"; then
    echo ""
    echo "=========================================="
    echo "✓ Installation Complete!"
    echo "=========================================="
    echo ""
    echo "Open WebUI is running at:"
    echo "  http://localhost:8080"
    echo ""
    echo "The model 'qwen2.5-coder:7b' should be automatically available!"
    echo ""
    echo "First-time setup:"
    echo "  1. Open http://localhost:8080 in your browser"
    echo "  2. Create an admin account (first user becomes admin)"
    echo "  3. The model should appear automatically in the dropdown"
    echo "  4. Start chatting!"
    echo ""
    echo "Command line usage:"
    echo "  ollama run qwen2.5-coder:7b"
    echo ""
    echo "To manage the web UI:"
    echo "  docker stop open-webui     # Stop"
    echo "  docker start open-webui    # Start"
    echo "  docker restart open-webui  # Restart"
    echo "  docker logs open-webui     # View logs"
    echo ""
    echo "To check Ollama models:"
    echo "  ollama list"
    echo ""
    echo "IMPORTANT: Log out and back in (or reboot)"
    echo "to use docker commands without sudo."
    echo ""
else
    echo "ERROR: Open WebUI container failed to start"
    echo "Check logs with: sudo docker logs open-webui"
    exit 1
fi

# Function to display additional models menu
show_additional_models_menu() {
    echo ""
    echo "=========================================="
    echo "Additional Model Installation"
    echo "=========================================="
    echo ""
    echo "Recommended models for your hardware:"
    echo ""
    echo "Coding Models:"
    echo "  1) starcoder2:7b        - Strong code completion (4GB)"
    echo "  2) phi-3.5              - Fast, efficient coding (2.3GB)"
    echo "  3) codellama:7b         - Original CodeLlama (3.8GB)"
    echo ""
    echo "General Purpose:"
    echo "  4) mistral:7b           - Great all-rounder (4.1GB)"
    echo "  5) llama3.2:3b          - Fast general use (2GB)"
    echo "  6) gemma2:2b            - Tiny but capable (1.6GB)"
    echo ""
    echo "Specialized:"
    echo "  7) sqlcoder:7b          - SQL specialist (4.1GB)"
    echo "  8) nous-hermes2:10.7b   - Creative writing (WARNING: 6.6GB, slower)"
    echo ""
    echo "  9) Custom model         - Enter model name manually"
    echo "  0) Skip / Exit"
    echo ""
}

# Function to pull a model
pull_model() {
    local model_name=$1
    echo ""
    echo "Downloading $model_name..."
    echo "This may take several minutes depending on model size..."
    if ollama pull "$model_name"; then
        echo "✓ Successfully installed $model_name"
        return 0
    else
        echo "✗ Failed to install $model_name"
        return 1
    fi
}

# Additional models installation loop
install_more_models() {
    while true; do
        show_additional_models_menu
        read -p "Select a model to install (0-9): " choice
        
        case $choice in
            1)
                pull_model "starcoder2:7b"
                ;;
            2)
                pull_model "phi-3.5"
                ;;
            3)
                pull_model "codellama:7b"
                ;;
            4)
                pull_model "mistral:7b"
                ;;
            5)
                pull_model "llama3.2:3b"
                ;;
            6)
                pull_model "gemma2:2b"
                ;;
            7)
                pull_model "sqlcoder:7b"
                ;;
            8)
                echo ""
                read -p "WARNING: This is a 10.7B model and will be slow on your hardware. Continue? (y/n): " confirm
                if [[ $confirm == [yY] ]]; then
                    pull_model "nous-hermes2:10.7b"
                fi
                ;;
            9)
                echo ""
                echo "You can find models at: https://ollama.com/library"
                read -p "Enter model name (e.g., 'llama3.2:1b'): " custom_model
                if [ -n "$custom_model" ]; then
                    pull_model "$custom_model"
                fi
                ;;
            0)
                echo ""
                echo "Exiting model installation."
                break
                ;;
            *)
                echo "Invalid choice. Please select 0-9."
                ;;
        esac
        
        echo ""
        read -p "Install another model? (y/n): " continue_install
        if [[ ! $continue_install == [yY] ]]; then
            break
        fi
    done
    
    echo ""
    echo "Currently installed models:"
    ollama list
}

# Ask user if they want to install more models
echo ""
read -p "Would you like to install additional models now? (y/n): " install_more
if [[ $install_more == [yY] ]]; then
    install_more_models
else
    echo ""
    echo "You can install additional models later by running:"
    echo "  ollama pull <model-name>"
    echo ""
    echo "Or browse models at: https://ollama.com/library"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo "Access your AI at: http://localhost:8080"
echo ""
