# Node 1 First Setup - Step by Step

This guide will walk you through setting up Node 1 on your first mini PC.

## Prerequisites

- Ubuntu Server 22.04 LTS or 24.04 LTS installed
- Static IP configured (recommended: 192.168.1.10)
- SSH access enabled
- User account with sudo privileges

**Note**: This guide is for **Node 1 only**. See `shared/node-setup-summary.md` for what's needed on each node.

## Step 1: Initial System Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y


# Verify timezone
timedatectl
date
```

## Step 2: Install Docker and Docker Compose

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
# $USER automatically uses your current username - just copy and paste this command
sudo usermod -aG docker $USER

# Apply group changes (or log out and back in)
newgrp docker


# Verify installation
docker --version
docker compose version
```

## Step 3: Clone or Copy Your Homelab Files

If you have the homelab repository on another machine:

```bash
# Option A: If using git
git clone <your-repo-url> ~/homelab
cd ~/homelab

# Option B: If copying files manually
# Create directory structure
mkdir -p ~/homelab/node1
mkdir -p ~/homelab/shared

# Copy your docker-compose.yml and other files to ~/homelab/node1/
```

## Step 4: Set Up Environment Variables

```bash
cd ~/homelab/node1

# Copy the environment template
cp ../shared/env-template.txt .env

# Edit the .env file
nano .env
```

Generate secure passwords and update the `.env` file automatically:

**Option 1: Use the setup script (Easiest)**:

```bash
# Make script executable
chmod +x ../shared/scripts/setup-env-node1.sh

# Run the script
../shared/scripts/setup-env-node1.sh
```

**Option 2: Run commands directly**:

```bash
# Generate and replace passwords in .env file automatically
sed -i "s|DB_PASSWORD=your_db_password_here|DB_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|DB_ROOT_PASSWORD=your_db_root_password_here|DB_ROOT_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|REDIS_PASSWORD=your_redis_password_here|REDIS_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|AUTHENTIK_SECRET_KEY=generate_random_key_here|AUTHENTIK_SECRET_KEY=$(openssl rand -base64 32)|g" .env
sed -i "s|APP_URL=.*|APP_URL=http://192.168.1.10|g" .env

# Verify
grep -E "PASSWORD|SECRET_KEY|APP_URL" .env
```

## Step 5: Start Core Services (Database & Redis First)

```bash
cd ~/homelab/node1

# Start only MariaDB and Redis first
docker compose up -d mariadb redis

# Wait for MariaDB to be ready (check logs)
docker compose logs -f mariadb

# Once you see "ready for connections", press Ctrl+C and continue
```

## Step 6: Start Portainer (Recommended Next)

Portainer will help you manage everything else:

```bash
# Start Portainer
docker compose up -d portainer

# Wait a few seconds, then access at:
# http://YOUR_IP:8000
```

**First-time Portainer setup:**
1. Open http://YOUR_IP:8000 in your browser
2. Create an admin account (username and password)
3. Select "Docker" environment
4. Click "Connect" to add your local Docker

## Step 7: Start Pterodactyl Panel (If Using Docker)

**Note:** Pterodactyl Panel can be tricky in Docker. You may want to install it directly on the host instead (see alternative below).

### Option A: Docker Installation

```bash
# Start the panel
docker compose up -d panel

# Wait for it to start, then initialize
docker compose exec panel php artisan p:user:make
```

### Option B: Host Installation (Recommended)

If Docker installation doesn't work well, install directly on the host:

```bash
# Keep MariaDB and Redis running in Docker
docker compose up -d mariadb redis

# Follow official Pterodactyl installation guide:
# https://pterodactyl.io/panel/1.11/getting_started.html
```

## Step 8: Start Remaining Services

```bash
# Start Uptime Kuma (monitoring)
docker compose up -d uptime-kuma

# Start Authentik (optional - authentication)
docker compose up -d authentik
```

## Step 9: Verify Everything is Running

```bash
# Check all containers
docker compose ps

# Or use Portainer UI to see all containers

# Check logs if anything isn't working
docker compose logs [service_name]
```

## Step 10: Access Your Services

Once everything is running, you can access:

- **Portainer**: http://YOUR_IP:8000
- **Pterodactyl Panel**: http://YOUR_IP (port 80)
- **Uptime Kuma**: http://YOUR_IP:3001
- **Authentik**: http://YOUR_IP:9000 (if enabled)

## Troubleshooting

### Portainer won't start
```bash
# Check logs
docker compose logs portainer

# Ensure Docker socket is accessible
ls -la /var/run/docker.sock
```

### MariaDB connection issues
```bash
# Check if MariaDB is ready
docker compose exec mariadb mysqladmin ping -h localhost

# Check MariaDB logs
docker compose logs mariadb
```

### Can't access services from browser
- Check firewall: `sudo ufw status`
- Allow ports: `sudo ufw allow 8000,80,3001,9000/tcp`
- Check if services are listening: `sudo netstat -tlnp | grep -E '8000|80|3001|9000'`

### Permission denied errors
```bash
# Ensure user is in docker group
groups

# If not, add and re-login
sudo usermod -aG docker $USER
newgrp docker
```

## Next Steps

Once Node 1 is set up and working:

1. **Test Portainer** - Make sure you can see all containers and manage them
2. **Set up Pterodactyl Panel** - Create your first admin user
3. **Configure Uptime Kuma** - Add monitors for your services
4. **Move to Node 2** - Set up Wings and Servarr stack (requires Panel to be ready)

## Quick Commands Reference

```bash
# View all running containers
docker compose ps

# View logs
docker compose logs -f [service_name]

# Restart a service
docker compose restart [service_name]

# Stop all services
docker compose down

# Start all services
docker compose up -d

# Update containers
docker compose pull
docker compose up -d
```

## Important Notes

- **Save your passwords** - Store the `.env` file securely (it's in .gitignore)
- **Don't expose to internet yet** - Set up firewall rules first
- **Node 2 depends on Node 1** - Wings needs the Panel to be running
- **Portainer is your friend** - Use it to manage everything visually

