# Homelab Setup Guide

## Hardware
- 3x Dell Optiplex 9020M Micro Desktop
  - CPU: Intel i5
  - RAM: 4GB each
  - Storage: 500GB SATA III each

## Location & Timezone
- **Location**: London, UK
- **Timezone**: Europe/London (GMT/BST)
- All services configured for UK timezone
- See `shared/location-config.md` for remote access considerations

## Operating System Recommendation

### **Ubuntu Server 22.04 LTS or 24.04 LTS** (Recommended)

**Why Ubuntu Server?**
- Excellent Docker support and documentation
- Large community and extensive tutorials
- LTS releases provide long-term support
- Well-suited for homelab environments
- Easy to manage remotely via SSH

**Alternative Options:**
- **Debian 12** - More lightweight, great for older hardware, very stable
- **Proxmox VE** - If you want virtualization + containers (overkill for this use case)
- **TrueNAS Scale** - If you need NAS features (you already have Synology)

### Installation Steps

1. Download Ubuntu Server ISO from [ubuntu.com](https://ubuntu.com/download/server)
2. Create bootable USB drive
3. Install on each Optiplex 9020M
4. During installation:
   - Enable SSH server
   - Install Docker (or do it post-install)
   - Set static IP addresses for each machine

## Architecture Overview

### Node 1: Pterodactyl Panel + Core Services
- Homepage (landing page dashboard)
- Pterodactyl Panel (web interface)
- Portainer (Docker management UI)
- UniFi Controller (network management)
- MySQL/MariaDB (for Pterodactyl)
- Redis (for Pterodactyl)
- Uptime Kuma (monitoring)
- Authentik (authentication - optional)

### Node 2: Pterodactyl Wings + Servarr Stack
- Pterodactyl Wings (game server daemon)
- Sonarr (TV shows)
- Radarr (Movies)
- Lidarr (Music)
- Readarr (Books & Audiobooks)
- Bazarr (Subtitles)
- Prowlarr (Indexer manager)
- qBittorrent (Download client)
- Overseerr (Request management)
- Ombi (Alternative request management)
- Tautulli (Plex monitoring & analytics)
- Mylar (Comic book management)

### Node 3: Additional Services
- Grafana + InfluxDB + Telegraf (Monitoring stack)
- Stirling PDF
- Docmost (Documentation)
- Linkwarden (Bookmarks)
- OctoPrint (3D printer management)
- **Optional (commented out to reduce RAM usage):**
  - Immich (Photo management) - ~512MB
  - Nextcloud (File sync) - ~768MB (with DB)
  
**Note:** Immich and Nextcloud are commented out in the default config to reduce Node 3's RAM usage from ~3.2GB to ~1.9GB. Use `docker-compose.full.yml` if you need them.

## Network Configuration

### Recommended IP Scheme
- **Node 1**: 192.168.1.10
- **Node 2**: 192.168.1.11
- **Node 3**: 192.168.1.12

### Ports to Consider
- Pterodactyl Panel: 80, 443
- Pterodactyl Wings: 8080 (default)
- Game servers: 25565+ (dynamic allocation)
- Servarr stack: Various (see docker-compose files)

## Storage Strategy

Since you have a Synology NAS:
- **Current Setup**: Downloads go directly to NAS (`/mnt/nas/downloads`)
- Use NAS for media storage (movies, TV shows, music)
- Use NAS for Pterodactyl server data (mount via NFS)
- Local drives for Docker volumes and temporary data
- Consider setting up NFS shares on Synology for:
  - `/media/downloads` - Download location
  - `/media/tv` - TV shows
  - `/media/movies` - Movies
  - `/media/music` - Music
  - `/pterodactyl/servers` - Game server data

**Note:** If you're concerned about Node 2's storage, see `shared/storage-options-node2.md` for options including:
- Adding a second drive (USB or internal)
- Using local drive for downloads, NAS for completed media
- Hybrid approach for optimal performance

## Getting Started

1. Install Ubuntu Server on all 3 machines
2. Set up SSH access and static IPs
3. Install Docker and Docker Compose on each node
4. Configure NFS mounts from Synology NAS
5. Deploy services using the provided docker-compose files

## Directory Structure

```
homelab/
├── node1/          # Pterodactyl Panel + Core Services
├── node2/          # Wings + Servarr Stack
├── node3/          # Additional Services
├── shared/         # Shared configurations
└── scripts/        # Deployment and maintenance scripts
```

