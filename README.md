# Local AI Coding Assistant - Debian Installer

Automated installation script for setting up a complete local AI development environment on Debian 13. Includes Ollama, Qwen2.5-Coder model, and Open WebUI for a ChatGPT-like interface - all running locally on your machine.

## 🎯 Features

- **Fully Offline AI** - No internet required after initial setup
- **Web Interface** - Clean, modern ChatGPT-style UI
- **Coding Optimized** - Pre-configured with Qwen2.5-Coder for Python, Bash, HTML, CSS
- **Interactive Model Manager** - Easy installation of additional AI models
- **Resource Efficient** - Optimized for laptops with 16GB RAM and integrated graphics
- **One-Command Setup** - Automated installation of all dependencies

## 🖥️ System Requirements

- **OS:** Debian 13 (Trixie)
- **RAM:** 16GB minimum
- **Storage:** 10GB+ free space (for models)
- **CPU:** Intel i5 or equivalent
- **GPU:** Not required (Intel HD Graphics 520 works fine)

## 🚀 Quick Start
```bash
# Download the installer
wget https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install_ollama.sh

# Make it executable
chmod +x install_ollama.sh

# Run the installer
./install_ollama.sh
```

After installation, open your browser to:
```
http://localhost:8080
```

## 📦 What Gets Installed

1. **Docker** - Container platform (from official Docker repo)
2. **Ollama** - Local LLM runtime
3. **Qwen2.5-Coder:7b** - 4.7GB coding-optimized AI model
4. **Open WebUI** - Web-based chat interface

## 🤖 Available Models

The installer offers these additional models:

### Coding Models
- `qwen2.5-coder:7b` ⭐ (Pre-installed)
- `starcoder2:7b` - Strong code completion
- `phi-3.5` - Fast and efficient
- `codellama:7b` - Meta's code model
- `sqlcoder:7b` - SQL specialist

### General Purpose
- `mistral:7b` - Excellent all-rounder
- `llama3.2:3b` - Faster, smaller model
- `gemma2:2b` - Tiny but capable

## 💻 Usage

### Web Interface
```bash
# Open browser to http://localhost:8080
# Create account (first user is admin)
# Select model from dropdown
# Start chatting!
```

### Command Line
```bash
# Interactive chat
ollama run qwen2.5-coder:7b

# One-off question
ollama run qwen2.5-coder:7b "Write a Python function to parse CSV files"

# Pipe code for explanation
cat script.py | ollama run qwen2.5-coder:7b "Explain this code"
```

### Docker Management
```bash
docker stop open-webui      # Stop web UI
docker start open-webui     # Start web UI
docker restart open-webui   # Restart web UI
docker logs open-webui      # View logs
```

### Model Management
```bash
ollama list                    # List installed models
ollama pull mistral:7b        # Install new model
ollama rm codellama:7b        # Remove model
```

## 🔧 Troubleshooting

### Web UI can't connect to Ollama
```bash
# Check Ollama is running
sudo systemctl status ollama

# Verify Ollama API is accessible
curl http://localhost:11434/api/tags

# Restart services
sudo systemctl restart ollama
docker restart open-webui
```

### Docker permission issues
```bash
# Log out and back in, or run:
newgrp docker

# Or reboot your system
```

### Model not appearing in Web UI
```bash
# Check Ollama models
ollama list

# Check Open WebUI logs
docker logs open-webui

# Verify connection
curl http://localhost:11434/api/tags
```

## 🛠️ Configuration

### Change Ollama host/port
Edit `/etc/systemd/system/ollama.service.d/override.conf`:
```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
```

Then restart:
```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

### Change Web UI port
Modify the docker run command to use different port:
```bash
docker stop open-webui
docker rm open-webui
docker run -d --name open-webui --network host \
  -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  -e PORT=3000 \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
```

## 📚 Resources

- [Ollama Documentation](https://ollama.com)
- [Open WebUI GitHub](https://github.com/open-webui/open-webui)
- [Ollama Model Library](https://ollama.com/library)
- [Qwen2.5-Coder Details](https://ollama.com/library/qwen2.5-coder)

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## 📝 License

MIT License - feel free to use this for personal or commercial projects.

## ⚠️ Disclaimer

This project installs third-party software. Make sure you comply with the licenses of:
- Docker (Apache 2.0)
- Ollama (MIT)
- Open WebUI (MIT)
- Individual AI models (varies by model)

## 🌟 Acknowledgments

- [Ollama](https://ollama.com) - Local LLM runtime
- [Open WebUI](https://github.com/open-webui/open-webui) - Web interface
- [Alibaba Cloud](https://github.com/QwenLM) - Qwen2.5-Coder model

---

**Made with ❤️ for developers who want AI without the cloud**
```

---

## **GitHub Topics/Tags to Add:**
```
ollama, ai, local-ai, llm, debian, docker, web-ui, coding-assistant, 
qwen, offline-ai, chatgpt-alternative, open-webui, self-hosted, 
machine-learning, artificial-intelligence, developer-tools
