# Remote AI Dev Server

A Docker container for remote development with Claude Code and Gemini CLI, accessible via SSH/Mosh through Tailscale.

## Features

- Ubuntu 22.04 base
- SSH server with key-based authentication
- Mosh support for unreliable connections
- Easy setup script for Claude Code CLI and Gemini CLI
- Node.js 20.x pre-installed
- Persistent workspace
- Access to Unraid shares
- Automatic builds via GitHub Actions

## Quick Start

### 1. Clone and Configure

```bash
git clone https://github.com/YOUR_USERNAME/ai-dev-server.git
cd ai-dev-server

# Copy environment template
cp .env.example .env

# Edit .env with your settings
nano .env
```

### 2. Set Up SSH Keys

```bash
# Create ssh-keys directory
mkdir -p ssh-keys

# Add your public key
cat ~/.ssh/id_ed25519.pub > ssh-keys/authorized_keys
chmod 600 ssh-keys/authorized_keys
```

### 3. Build and Run

#### Option A: Build Locally
```bash
docker-compose up -d --build
```

#### Option B: Pull from GHCR (after GitHub Actions builds)
```bash
# Update docker-compose.yml to use:
# image: ghcr.io/YOUR_USERNAME/remote-dev:latest

docker-compose pull
docker-compose up -d
```

## Connecting

### Via SSH (through Tailscale)
```bash
# From any device on your Tailscale network
ssh -p 2222 jon@your-unraid-hostname.ts.net

# Or if you've set up Tailscale SSH
ssh your-unraid-hostname:2222
```

### Via Mosh (better for travel)
```bash
mosh --ssh="ssh -p 2222" jon@your-unraid-hostname.ts.net
```

## First-Time Setup

After connecting for the first time, run the setup script to install AI tools:

```bash
# Run the setup script
~/setup-ai-tools.sh
```

This will install:
- Claude Code CLI
- Gemini CLI (via npm)

The script is idempotent - you can run it multiple times safely.

## Using AI Tools

Once setup is complete:

```bash
# Claude Code
claude

# Gemini CLI
npx @google/generative-ai

# Your workspace is persistent at
cd ~/workspace
```

## Configuration

### Environment Variables

Edit `.env` to customize:

- `USER_NAME`: Username inside container (default: jon)
- `SSH_PORT`: Host port for SSH (default: 2222)
- `WORKSPACE_PATH`: Path for persistent storage
- `SSH_KEYS_PATH`: Path to your authorized_keys file

### Adding Unraid Shares

Edit `docker-compose.yml` to mount additional shares:

```yaml
volumes:
  - /mnt/user/documents:/mnt/shares/documents:ro
  - /mnt/user/media:/mnt/shares/media:ro
```

### API Keys

Store API keys in the config directory:

```bash
# Create config directory
mkdir -p config

# Add your keys (these won't be committed to git)
echo "your-api-key" > config/claude-api-key
echo "your-gemini-key" > config/gemini-api-key
```

Then access them in the container at `~/.config/`

## Building from Source

```bash
# Build the image
docker build -t remote-dev:latest .

# Or use docker-compose
docker-compose build
```

## GitHub Container Registry

This repo includes a GitHub Action that automatically builds and publishes to GHCR on push to main.

To use the published image:

1. Update `docker-compose.yml`:
   ```yaml
   image: ghcr.io/YOUR_USERNAME/remote-dev:latest
   ```

2. Pull and run:
   ```bash
   docker-compose pull
   docker-compose up -d
   ```

## Troubleshooting

### Can't connect via SSH
- Check Tailscale is running on Unraid
- Verify port 2222 is not blocked
- Check SSH key permissions: `ls -la ssh-keys/authorized_keys`

### Mosh not working
- Ensure UDP ports 60000-60010 are accessible
- Check firewall settings on Unraid

### Permission issues
- Verify USER_UID and USER_GID in `.env` match your host user

## License

MIT
