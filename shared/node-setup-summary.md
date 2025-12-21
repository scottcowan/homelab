# Node Setup Summary - What's Needed on Each Node

## What's the Same on All Nodes

### Required on All 3 Nodes:

1. **Ubuntu Server Installation** ✅
   - Same installation steps
   - Same profile configuration (but different hostnames)
   - Same initial setup

2. **Docker Installation** ✅
   - Install Docker and Docker Compose on all nodes
   - Same commands on all nodes

3. **Basic System Setup** ✅
   - Timezone: Europe/London
   - Static IP configuration (different IPs)
   - SSH access
   - Package mirror: UK

## What's Different on Each Node

### Node 1 (192.168.1.10)

**Setup Steps**:
1. ✅ Install Docker
2. ✅ Copy homelab files to `~/homelab/node1/`
3. ✅ Create `.env` file with:
   - DB_PASSWORD
   - DB_ROOT_PASSWORD
   - REDIS_PASSWORD
   - AUTHENTIK_SECRET_KEY
   - APP_URL=http://192.168.1.10
4. ✅ Start services: mariadb, redis, portainer, homepage, unifi, uptime-kuma, authentik, panel

**Services**:
- Pterodactyl Panel
- Portainer
- Homepage
- UniFi Controller
- MariaDB
- Redis
- Uptime Kuma
- Authentik

### Node 2 (192.168.1.11)

**Setup Steps**:
1. ✅ Install Docker (same as Node 1)
2. ✅ Copy homelab files to `~/homelab/node2/`
3. ✅ Create `.env` file with:
   - WINGS_TOKEN (get from Pterodactyl Panel after Node 1 is set up)
4. ✅ Configure NFS mounts from Synology NAS
5. ✅ Start services: wings, prowlarr, qbittorrent, sonarr, radarr, lidarr, readarr, bazarr, overseerr, ombi, tautulli, mylar

**Services**:
- Pterodactyl Wings
- Servarr Stack (Sonarr, Radarr, Lidarr, Readarr, Bazarr)
- Prowlarr
- qBittorrent
- Overseerr
- Ombi
- Tautulli
- Mylar

**Additional Setup**:
- NFS mounts for NAS storage
- Wings token from Pterodactyl Panel

### Node 3 (192.168.1.12)

**Setup Steps**:
1. ✅ Install Docker (same as Node 1)
2. ✅ Copy homelab files to `~/homelab/node3/`
3. ✅ Create `.env` file with:
   - GRAFANA_PASSWORD
   - INFLUXDB_PASSWORD
   - INFLUXDB_TOKEN (generate after InfluxDB setup)
   - DOCMOST_PASSWORD
   - DOCMOST_SECRET_KEY
   - LINKWARDEN_PASSWORD
   - LINKWARDEN_SECRET
4. ✅ Start services: grafana, influxdb, telegraf, stirling-pdf, docmost, linkwarden, octoprint

**Services**:
- Grafana
- InfluxDB
- Telegraf
- Stirling PDF
- Docmost
- Linkwarden
- OctoPrint

## Quick Setup Checklist

### All Nodes (Do This First)

- [ ] Install Ubuntu Server
- [ ] Set static IP (192.168.1.10, .11, .12)
- [ ] Set timezone: Europe/London
- [ ] Change package mirror to UK
- [ ] Install Docker
- [ ] Install Docker Compose
- [ ] Copy homelab repository files

### Node 1 Only

- [ ] Create `.env` file with database passwords
- [ ] Start mariadb, redis
- [ ] Start portainer, homepage, unifi
- [ ] Start pterodactyl panel (or install on host)
- [ ] Set up Pterodactyl Panel admin user

### Node 2 Only

- [ ] Configure NFS mounts from NAS
- [ ] Create `.env` file with WINGS_TOKEN
- [ ] Get Wings token from Pterodactyl Panel (after Node 1 is ready)
- [ ] Start all Servarr services

### Node 3 Only

- [ ] Create `.env` file with monitoring passwords
- [ ] Start monitoring stack (Grafana, InfluxDB, Telegraf)
- [ ] Start other services

## Setup Order

**Recommended order**:

1. **Node 1 first** (foundation)
   - Pterodactyl Panel needed before Wings
   - Portainer helps manage everything

2. **Node 2 second** (after Node 1 Panel is ready)
   - Wings needs Panel to be running
   - Get Wings token from Panel

3. **Node 3 third** (independent)
   - Can be set up anytime
   - Doesn't depend on other nodes

## Environment Files

Each node needs a different `.env` file:

- **Node 1**: Database passwords, Redis password, Authentik key
- **Node 2**: Wings token (from Panel)
- **Node 3**: Grafana, InfluxDB, Docmost, Linkwarden passwords

## Docker Installation (Same on All)

This is identical on all 3 nodes:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker compose version
```

## Summary

**Same on all nodes**:
- Ubuntu installation
- Docker installation
- Basic system setup

**Different on each node**:
- Hostname (node1, node2, node3)
- Static IP (192.168.1.10, .11, .12)
- Services (different docker-compose.yml)
- Environment variables (different .env files)
- Additional setup (NFS on Node 2, etc.)

**Setup order**: Node 1 → Node 2 → Node 3

