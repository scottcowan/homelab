# Quick Reference Guide

## Service URLs

### Node 1 (192.168.1.10)
- **Homepage**: http://192.168.1.10:3000 (Landing Page)
- **Pterodactyl Panel**: http://192.168.1.10
- **Portainer**: http://192.168.1.10:8000 (HTTPS: https://192.168.1.10:8443)
- **UniFi Controller**: https://192.168.1.10:8443
- **Uptime Kuma**: http://192.168.1.10:3001
- **Authentik**: http://192.168.1.10:9000

### Node 2 (192.168.1.11)
- **Pterodactyl Wings**: http://192.168.1.11:8080
- **Prowlarr**: http://192.168.1.11:9696
- **qBittorrent**: http://192.168.1.11:8081
- **Sonarr**: http://192.168.1.11:8989
- **Radarr**: http://192.168.1.11:7878
- **Lidarr**: http://192.168.1.11:8686
- **Readarr**: http://192.168.1.11:8787
- **Bazarr**: http://192.168.1.11:6767
- **Overseerr**: http://192.168.1.11:5055
- **Ombi**: http://192.168.1.11:3579
- **Tautulli**: http://192.168.1.11:8181
- **Mylar**: http://192.168.1.11:8090

### Node 3 (192.168.1.12) - Light Configuration
- **Grafana**: http://192.168.1.12:3000
- **InfluxDB**: http://192.168.1.12:8086
- **Stirling PDF**: http://192.168.1.12:8083
- **Docmost**: http://192.168.1.12:3002
- **Linkwarden**: http://192.168.1.12:3003
- **OctoPrint**: http://192.168.1.12:5000

### Node 3 (192.168.1.12) - Full Configuration (if using Immich & Nextcloud)
- **Nextcloud**: http://192.168.1.12:8080
- **Immich**: http://192.168.1.12:2283

## Default Credentials

### qBittorrent
- Username: `admin`
- Password: `adminadmin` (change immediately!)

### Grafana
- Username: `admin`
- Password: Set in `.env` file

### InfluxDB
- Username: `admin`
- Password: Set in `.env` file

## Common Commands

### Check all containers
```bash
docker ps -a
```

### View logs
```bash
docker compose logs -f [service_name]
```

### Restart a service
```bash
docker compose restart [service_name]
```

### Update all containers
```bash
docker compose pull
docker compose up -d
```

### Check resource usage
```bash
docker stats
```

### Backup a volume
```bash
docker run --rm -v [volume_name]:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data
```

### Restore a volume
```bash
docker run --rm -v [volume_name]:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /data
```

## Port Reference

| Service | Port | Protocol |
|---------|------|----------|
| Pterodactyl Panel | 80, 443 | HTTP/HTTPS |
| Portainer | 8000, 8443 | HTTP/HTTPS |
| Pterodactyl Wings | 8080 | HTTP |
| Uptime Kuma | 3001 | HTTP |
| Authentik | 9000, 9443 | HTTP/HTTPS |
| Prowlarr | 9696 | HTTP |
| qBittorrent | 8081 | HTTP |
| qBittorrent | 6881 | TCP/UDP |
| Sonarr | 8989 | HTTP |
| Radarr | 7878 | HTTP |
| Lidarr | 8686 | HTTP |
| Readarr | 8787 | HTTP |
| Bazarr | 6767 | HTTP |
| Overseerr | 5055 | HTTP |
| Ombi | 3579 | HTTP |
| Tautulli | 8181 | HTTP |
| Mylar | 8090 | HTTP |
| Homepage | 3000 | HTTP |
| UniFi Controller | 8443 | HTTPS |
| OctoPrint | 5000 | HTTP |
| Grafana | 3000 | HTTP |
| InfluxDB | 8086 | HTTP |
| Nextcloud | 8080 | HTTP |
| Immich | 2283 | HTTP |
| Stirling PDF | 8083 | HTTP |
| Docmost | 3002 | HTTP |
| Linkwarden | 3003 | HTTP |

## Resource Allocation

### Node 1 (4GB RAM)
- Pterodactyl Panel: ~512MB
- MariaDB: ~256MB
- Redis: ~128MB
- Portainer: ~128MB
- Homepage: ~128MB
- UniFi Controller: ~512MB
- Uptime Kuma: ~128MB
- Authentik: ~512MB
- **Total**: ~2.3GB (leaves 1.7GB for system)

### Node 2 (4GB RAM)
- Wings: ~512MB
- Prowlarr: ~256MB
- qBittorrent: ~512MB
- Sonarr: ~256MB
- Radarr: ~256MB
- Lidarr: ~256MB
- Readarr: ~256MB
- Bazarr: ~128MB
- Overseerr: ~256MB
- Ombi: ~256MB
- Tautulli: ~256MB
- Mylar: ~256MB
- **Total**: ~3.3GB (leaves 700MB for system)

### Node 3 (4GB RAM) - Light Configuration
- Grafana: ~256MB
- InfluxDB: ~512MB
- Telegraf: ~128MB
- Stirling PDF: ~256MB
- Docmost: ~256MB
- Docmost DB: ~128MB
- Linkwarden: ~256MB
- Linkwarden DB: ~128MB
- OctoPrint: ~256MB
- **Total**: ~2.2GB (leaves 1.8GB for system) ✅

### Node 3 (4GB RAM) - Full Configuration (with Immich & Nextcloud)
- Immich: ~512MB
- Nextcloud: ~512MB
- Nextcloud DB: ~256MB
- Grafana: ~256MB
- InfluxDB: ~512MB
- Telegraf: ~128MB
- Stirling PDF: ~256MB
- Docmost: ~256MB
- Docmost DB: ~128MB
- Linkwarden: ~256MB
- Linkwarden DB: ~128MB
- **Total**: ~3.2GB (leaves 800MB for system - may need optimization)

## Important Notes

1. **Node 3 is resource-constrained** - Consider moving some services to other nodes or upgrading RAM
2. **NFS mounts** must be configured before starting services that need NAS access
3. **Pterodactyl Panel** may need to be installed directly on the host (not in Docker) for better compatibility
4. **Game server ports** are dynamically allocated by Pterodactyl (25565+)
5. **Change all default passwords** immediately after first login

