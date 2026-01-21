# Homelab Setup Guide

## Prerequisites

1. Ubuntu Server 22.04 LTS installed on all 3 machines
2. Static IP addresses configured
3. SSH access enabled
4. Synology NAS accessible on network
5. **Timezone**: All services configured for Europe/London (GMT/BST)

## Step 1: Install Docker and Docker Compose

On each node, run:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo apt install docker-compose-plugin -y

# Verify installation
docker --version
docker compose version
```

## Step 2: Configure NFS Mounts from Synology NAS

On each node that needs NAS access (Node 2 and Node 3):

```bash
# Install NFS client
sudo apt install nfs-common -y

# Create mount points
sudo mkdir -p /mnt/nas/{downloads,tv,movies,music,photos,nextcloud}

# Add to /etc/fstab (replace NAS_IP with your Synology IP)
# Example:
# NAS_IP:/volume1/downloads /mnt/nas/downloads nfs defaults 0 0
# NAS_IP:/volume1/tv /mnt/nas/tv nfs defaults 0 0
# NAS_IP:/volume1/movies /mnt/nas/movies nfs defaults 0 0
# NAS_IP:/volume1/music /mnt/nas/music nfs defaults 0 0
# NAS_IP:/volume1/photos /mnt/nas/photos nfs defaults 0 0
# NAS_IP:/volume1/nextcloud /mnt/nas/nextcloud nfs defaults 0 0

# Mount
sudo mount -a
```

**Note:** Configure NFS shares on your Synology NAS first:
1. Control Panel → Shared Folder
2. Create folders: downloads, tv, movies, music, photos, nextcloud
3. Control Panel → File Services → NFS
4. Enable NFS and configure permissions for each share

## Step 3: Set Up Node 1 (Pterodactyl Panel)

**Important Note:** Pterodactyl Panel can be run in Docker (as shown below) or installed directly on the host. The official documentation recommends host installation for production, but Docker works well for homelab use.

### Option A: Docker Installation (Easier)

```bash
cd ~/homelab/node1

# Copy environment file
cp ../shared/env-template.txt .env

# Edit .env with your passwords
nano .env

# Generate secure passwords (run these commands)
openssl rand -base64 32  # For DB_PASSWORD
openssl rand -base64 32  # For DB_ROOT_PASSWORD
openssl rand -base64 32  # For REDIS_PASSWORD
openssl rand -base64 32  # For AUTHENTIK_SECRET_KEY

# Start services
docker compose up -d

# Wait for MariaDB to be ready (check logs: docker compose logs mariadb)
# Then initialize Pterodactyl Panel
docker compose exec panel php artisan p:user:make
```

### Option B: Host Installation (Recommended for Production)

Follow the official Pterodactyl installation guide:
https://pterodactyl.io/panel/1.11/getting_started.html

You can still use Docker for MariaDB and Redis:
```bash
cd ~/homelab/node1
docker compose up -d mariadb redis
```

Then install the panel directly on the host following Pterodactyl's documentation.

## Step 4: Set Up Node 2 (Wings + Servarr Stack)

```bash
cd ~/homelab/node2

# Copy Node 2 environment template
cp ../shared/env-template-node2.txt .env

# Set up Wings token using script (interactive)
chmod +x ../shared/scripts/setup-env-node2.sh
../shared/scripts/setup-env-node2.sh

# Or manually edit:
# 1. Get Wings token from Pterodactyl Panel (http://192.168.1.10)
# 2. Go to Configuration → Nodes → Create/Edit Node
# 3. Copy the Wings token
# 4. Edit .env: nano .env
# 5. Replace WINGS_TOKEN=your_wings_token_here with your token

# Start services
docker compose up -d

# Configure Servarr apps:
# - Sonarr: http://192.168.1.11:8989
# - Radarr: http://192.168.1.11:7878
# - Lidarr: http://192.168.1.11:8686
# - Prowlarr: http://192.168.1.11:9696
# - qBittorrent: http://192.168.1.11:8081
# - Overseerr: http://192.168.1.11:5055
```

## Step 5: Set Up Node 3 (Additional Services)

```bash
cd ~/homelab/node3

# Copy Node 3 environment template
cp ../shared/env-template-node3.txt .env

# Generate passwords automatically using script
chmod +x ../shared/scripts/setup-env-node3.sh
../shared/scripts/setup-env-node3.sh

# Note: INFLUXDB_TOKEN will be set after InfluxDB is running
# Access InfluxDB at http://192.168.1.12:8086 to get the token

# Start services
docker compose up -d

# Access services:
# - Grafana: http://192.168.1.12:3000
# - InfluxDB: http://192.168.1.12:8086
# - Nextcloud: http://192.168.1.12:8080
# - Immich: http://192.168.1.12:2283
# - Stirling PDF: http://192.168.1.12:8083
# - Docmost: http://192.168.1.12:3002
# - Linkwarden: http://192.168.1.12:3003
```

## Step 6: Configure Pterodactyl Wings

1. Log into Pterodactyl Panel at http://192.168.1.10
2. Go to Configuration → Nodes
3. Create a new node:
   - Name: Node 2
   - FQDN: 192.168.1.11
   - Port: 8080
   - Memory: 3072 MB (leave 1GB for system)
   - Disk: 400000 MB (leave 100GB for system)
4. Copy the Wings token
5. Update Node 2's .env file with the token
6. Restart Wings: `docker compose restart wings`

## Step 7: Configure Servarr Stack

### Initial Setup Order:
1. **Prowlarr** (http://192.168.1.11:9696)
   - Add indexers (Torrent sites, Usenet providers)
   - Configure download client (qBittorrent)

2. **qBittorrent** (http://192.168.1.11:8081)
   - Default login: admin/adminadmin
   - Change password immediately
   - Configure download paths

3. **Sonarr** (http://192.168.1.11:8989)
   - Connect to Prowlarr
   - Connect to qBittorrent
   - Configure media paths

4. **Radarr** (http://192.168.1.11:7878)
   - Connect to Prowlarr
   - Connect to qBittorrent
   - Configure media paths

5. **Lidarr** (http://192.168.1.11:8686)
   - Connect to Prowlarr
   - Connect to qBittorrent
   - Configure media paths

6. **Readarr** (http://192.168.1.11:8787)
   - Connect to Prowlarr
   - Connect to qBittorrent
   - Configure audiobook and book paths
   - Set up root folders for audiobooks and ebooks

7. **Bazarr** (http://192.168.1.11:6767)
   - Connect to Sonarr and Radarr
   - Configure subtitle providers

8. **Overseerr** (http://192.168.1.11:5055)
   - Connect to Sonarr and Radarr
   - Connect to Plex (your existing server)

## Step 8: Configure Monitoring

### Uptime Kuma (Node 1)
- Access: http://192.168.1.10:3001
- Add monitors for all your services
- Set up notifications (email, Discord, etc.)

### Grafana + InfluxDB (Node 3)
1. Access InfluxDB: http://192.168.1.12:8086
2. Complete initial setup
3. Create API token
4. Update Telegraf config with token
5. Access Grafana: http://192.168.1.12:3000
6. Add InfluxDB as data source
7. Import dashboards for Docker monitoring

## Maintenance

### Update all containers:
```bash
# On each node
cd ~/homelab/nodeX
docker compose pull
docker compose up -d
```

### Backup important data:
- Pterodactyl Panel database
- Servarr configs
- Nextcloud data
- Grafana dashboards

### Monitor resource usage:
```bash
docker stats
```

## Troubleshooting

### Check container logs:
```bash
docker compose logs [service_name]
```

### Check container status:
```bash
docker compose ps
```

### Restart a service:
```bash
docker compose restart [service_name]
```

### NFS mount issues:
```bash
# Check if mounted
mount | grep nfs

# Remount
sudo mount -a

# Check NFS server
showmount -e NAS_IP
```

