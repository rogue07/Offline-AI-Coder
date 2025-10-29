# Smart Coder - Intelligent Local AI Coding Assistant

Automated installation script for setting up a complete local AI development environment on Debian 13. Includes Ollama, a custom "Smart Coder" model that asks probing questions, and Open WebUI for a ChatGPT-like interface - all running locally on your machine.

## 🎯 Features

- **Fully Offline AI** - No internet required after initial setup
- **Intelligent Question Asking** - Custom AI that probes for requirements non-programmers might miss
- **Web Interface** - Clean, modern ChatGPT-style UI
- **Coding Optimized** - Pre-configured with Qwen2.5-Coder for Python, Bash, HTML, CSS
- **Interactive Model Manager** - Easy installation of additional AI models
- **Resource Efficient** - Optimized for laptops with 16GB RAM and integrated graphics
- **One-Command Setup** - Automated installation of all dependencies
- **Repository Conflict Resolution** - Automatically cleans up duplicate apt sources

## 🤖 What Makes "Smart Coder" Different?

Unlike standard coding assistants, Smart Coder acts like a senior software architect by asking critical questions before writing code:

### Questions It Asks:
- **Scale & Performance**: How much data? How many users? Speed requirements?
- **Input/Output**: Where does data come from? What format? Where should results go?
- **Error Handling**: What should happen when things go wrong?
- **User Interface**: Command line? Web interface? GUI? File-based?
- **Environment**: Where will this run? What's already installed?
- **Security**: Any sensitive data? Authentication needed?
- **Persistence**: Does data need to be saved? How?
- **Integration**: Need to work with other tools/services?
- **Edge Cases**: What unusual situations might occur?
- **Future Needs**: Will this need to grow or change?

### Example Interaction:

**You:** "Create a program to track my expenses"

**Smart Coder:** "I'd be happy to help you build an expense tracker! Let me ask a few questions to make sure I build exactly what you need:

1. **How do you want to input expenses?**
   - Type them in each time you run the program?
   - Import from a file (like CSV from your bank)?
   - Enter through a web form?

2. **What information do you want to track for each expense?**
   - Just amount and date?
   - Categories (food, transport, etc.)?
   - Payment method?
   - Notes or descriptions?

3. **How do you want to view your data?**
   - Simple text summary?
   - Charts/graphs?
   - Export to spreadsheet?

4. **Do you need to track multiple people or accounts**, or just your personal expenses?

These answers will help me build something that actually fits your workflow!"

## 🖥️ System Requirements

- **OS:** Debian 13 (Trixie)
- **RAM:** 16GB minimum
- **Storage:** 10GB+ free space (for models)
- **CPU:** Intel i5 or equivalent
- **GPU:** Not required (Intel HD Graphics 520 works fine)

## 🚀 Quick Start
```bash
# Download the installer
wget https://raw.githubusercontent.com/rogue07/YOUR_REPO/main/install_ollama.sh

# Make it executable
chmod +x install_ollama.sh

# Run the installer
./install_ollama.sh
```

After installation, open your browser to:
```
http://localhost:8080
```

**First-time setup:**
1. Create your admin account (first user becomes admin)
2. Select **"smart-coder"** from the model dropdown
3. Start building!

## 📦 What Gets Installed

1. **Docker** - Container platform (from official Docker repo)
2. **Ollama** - Local LLM runtime
3. **Qwen2.5-Coder:7b** - 4.7GB base coding model
4. **Smart Coder** - Custom model with intelligent questioning
5. **Open WebUI** - Web-based chat interface

## 🤖 Available Models

### Pre-Installed
- **smart-coder** ⭐ (RECOMMENDED) - Asks probing questions before coding
- **qwen2.5-coder:7b** - Standard coding model

### Additional Models (Optional)

#### Coding Models
- `starcoder2:7b` - Strong code completion (4GB)
- `phi-3.5` - Fast and efficient (2.3GB)
- `codellama:7b` - Meta's code model (3.8GB)
- `sqlcoder:7b` - SQL specialist (4.1GB)

#### General Purpose
- `mistral:7b` - Excellent all-rounder (4.1GB)
- `llama3.2:3b` - Faster, smaller model (2GB)
- `gemma2:2b` - Tiny but capable (1.6GB)

#### Creative/Specialized
- `nous-hermes2:10.7b` - Creative writing (WARNING: 6.6GB, slower on your hardware)

## 💻 Usage

### Web Interface
```bash
# Open browser to http://localhost:8080
# Create account (first user is admin)
# Select "smart-coder" from dropdown
# Start chatting!
```

### Command Line

#### Interactive Chat
```bash
# With intelligent questioning
ollama run smart-coder

# Standard coding model
ollama run qwen2.5-coder:7b
```

#### One-off Questions
```bash
ollama run smart-coder "Write a Python function to parse CSV files"
```

#### Code Explanation
```bash
cat script.py | ollama run smart-coder "Explain this code"
```

#### Get Requirements Advice
```bash
ollama run smart-coder "I want to build a todo list app"
# Smart Coder will ask probing questions before coding
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
ollama show smart-coder       # View model details
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
sudo reboot
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

### Duplicate repository warnings
The script automatically cleans these up, but if you see warnings about VirtualBox or other duplicate sources:
```bash
# Manual cleanup
sudo rm -f /etc/apt/sources.list.d/*virtualbox*
sudo rm -f /etc/apt/sources.list.d/archive_uri-*
sudo apt update
```

### Smart Coder isn't asking questions
Make sure you selected the "smart-coder" model, not "qwen2.5-coder:7b". The base model doesn't have the custom prompt.

### Responses are slow
This is normal on CPU-only systems. For faster responses:
- Use smaller models like `phi-3.5` or `gemma2:2b`
- Reduce context length in your prompts
- Close other heavy applications

## 🛠️ Advanced Configuration

### Customize Smart Coder's Behavior

Edit the system prompt by creating a new Modelfile:
```bash
nano ~/custom-coder-modelfile
```
```
FROM qwen2.5-coder:7b

SYSTEM """Your custom instructions here..."""

PARAMETER temperature 0.7
PARAMETER top_p 0.9
```

Create the model:
```bash
ollama create my-custom-coder -f ~/custom-coder-modelfile
```

### Change Ollama Host/Port

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

### Change Web UI Port

Stop and recreate the container with a different port:
```bash
docker stop open-webui
docker rm open-webui
docker run -d --name open-webui \
  --network host \
  -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  -e PORT=3000 \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
```

Access at: `http://localhost:3000`

### Add More RAM to Docker

If you want to run larger models, ensure Docker has access to more RAM:
```bash
# Check Docker info
docker info | grep -i memory
```

## 📚 Resources

- [Ollama Documentation](https://ollama.com)
- [Open WebUI GitHub](https://github.com/open-webui/open-webui)
- [Ollama Model Library](https://ollama.com/library)
- [Qwen2.5-Coder Details](https://ollama.com/library/qwen2.5-coder)
- [Modelfile Documentation](https://github.com/ollama/ollama/blob/main/docs/modelfile.md)

## 🎓 Tips for Best Results

### For Beginners
1. Always use **smart-coder** - it will guide you through the requirements
2. Be honest about your technical level - the AI adapts its explanations
3. Answer the probing questions - they help create better code
4. Ask for explanations of terms you don't understand

### For Experienced Developers
1. Use **qwen2.5-coder:7b** for direct coding without questions
2. Switch to **smart-coder** when planning new projects
3. Use command-line interface for quick snippets
4. Create custom Modelfiles for specialized workflows

### General Tips
- Start with small, working versions of your project
- Ask the AI to explain its code
- Request test cases and error handling
- Have the AI suggest improvements after the initial version

## 🤝 Contributing

Contributions welcome! Areas for improvement:

- Additional custom models for specific domains (web dev, data science, etc.)
- Integration with popular IDEs
- Voice interface options
- Mobile-friendly web UI themes
- Automated backup scripts

Please feel free to submit a Pull Request.

## 📝 License

MIT License - feel free to use this for personal or commercial projects.

## ⚠️ Disclaimer

This project installs third-party software. Make sure you comply with the licenses of:
- Docker (Apache 2.0)
- Ollama (MIT)
- Open WebUI (MIT)
- Qwen2.5-Coder (Apache 2.0)
- Individual AI models (varies by model - check model cards)

## 🌟 Acknowledgments

- [Ollama](https://ollama.com) - Local LLM runtime
- [Open WebUI](https://github.com/open-webui/open-webui) - Web interface
- [Alibaba Cloud](https://github.com/QwenLM) - Qwen2.5-Coder model
- The open-source AI community

## 💡 Why This Project Exists

Most coding assistants assume you know what to ask for. **Smart Coder** recognizes that great software starts with great requirements - and helps you think through what you actually need before writing a single line of code.

Perfect for:
- **Beginners** learning to code
- **Non-technical founders** building MVPs
- **Students** working on class projects
- **Hobbyists** exploring new ideas
- **Professionals** who want a second opinion on architecture

---

**Built with ❤️ for developers who value thoughtful design over quick hacks**

## 🔐 Privacy & Security

- **100% Local** - Your code and conversations never leave your machine
- **No Telemetry** - No data collection or tracking
- **Offline Capable** - Works without internet after installation
- **Full Control** - You own and control all data

---

## 📊 Performance Benchmarks

On Intel i5 with 16GB RAM and Intel HD Graphics 520:

| Model | Response Time | RAM Usage | Quality |
|-------|--------------|-----------|---------|
| smart-coder | 8-15s | ~5GB | ⭐⭐⭐⭐⭐ |
| qwen2.5-coder:7b | 8-15s | ~5GB | ⭐⭐⭐⭐⭐ |
| phi-3.5 | 4-8s | ~3GB | ⭐⭐⭐⭐ |
| mistral:7b | 10-18s | ~5GB | ⭐⭐⭐⭐ |

*Times are approximate for typical coding questions*

## 🎬 Quick Demo
```bash
# Start interactive session
ollama run smart-coder

# Try this prompt:
"I want to create a password manager"

# Watch as Smart Coder asks about:
# - Encryption requirements
# - Storage location preferences
# - Access patterns
# - Backup strategies
# - Platform compatibility
# And more!
```

---

**Questions? Issues? Feedback?**

Open an issue on GitHub or contribute to make Smart Coder even smarter! 🚀
