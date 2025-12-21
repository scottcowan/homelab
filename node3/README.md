# Node 3 Configuration

## Light vs Full Configuration

Node 3 has two configuration options:

### Light Configuration (Default - Recommended)

**File:** `docker-compose.yml`

**Services:**
- Grafana (Monitoring dashboard)
- InfluxDB (Time series database)
- Telegraf (Metrics collector)
- Stirling PDF (PDF editor)
- Docmost (Documentation)
- Linkwarden (Bookmarks)

**RAM Usage:** ~1.9GB (leaves 2.1GB for system) ✅

### Full Configuration (If You Need Immich & Nextcloud)

**File:** `docker-compose.full.yml` (or uncomment in docker-compose.yml)

**Additional Services:**
- Immich (Photo management) - ~512MB
- Nextcloud (File sync) - ~512MB
- Nextcloud DB - ~256MB

**RAM Usage:** ~3.2GB (leaves 800MB for system)

## Quick Start

### Light Configuration (Default)
```bash
cd ~/homelab/node3
docker compose up -d
```

### Full Configuration
```bash
cd ~/homelab/node3
# Option 1: Use the full compose file
docker compose -f docker-compose.full.yml up -d

# Option 2: Uncomment Immich and Nextcloud in docker-compose.yml
# Then use: docker compose up -d
```

## Why Light Configuration?

With only 4GB RAM on Node 3, removing Immich and Nextcloud:
- **Frees ~1.3GB RAM** (from 3.2GB to 1.9GB)
- **Leaves 2.1GB for system** (vs 800MB)
- **More stable** - less likely to run out of memory
- **Better performance** - more headroom for other services

## Alternative: Run Immich/Nextcloud Elsewhere

If you need Immich or Nextcloud, consider:
1. **Run on Node 1** - Has more available RAM
2. **Run on Node 2** - If you have extra resources
3. **Run on your Synology NAS** - Many Synology models support Docker

## Switching Between Configurations

### From Light to Full
```bash
# Stop light services
docker compose down

# Start full services
docker compose -f docker-compose.full.yml up -d
```

### From Full to Light
```bash
# Stop full services
docker compose -f docker-compose.full.yml down

# Start light services
docker compose up -d
```

## Service URLs

### Light Configuration
- Grafana: http://192.168.1.12:3000
- InfluxDB: http://192.168.1.12:8086
- Stirling PDF: http://192.168.1.12:8083
- Docmost: http://192.168.1.12:3002
- Linkwarden: http://192.168.1.12:3003

### Full Configuration (Additional)
- Nextcloud: http://192.168.1.12:8080
- Immich: http://192.168.1.12:2283

