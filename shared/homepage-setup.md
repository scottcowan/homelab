# Homepage Setup Guide

[Homepage](https://gethomepage.dev/) is a modern, fully static, fast, secure application dashboard that serves as your homelab landing page. It integrates with over 100 services and provides a beautiful interface to access all your services.

## Access

After starting the Homepage container:
- **URL**: http://192.168.1.10:3000

## Initial Setup

### Step 1: Start Homepage

```bash
cd ~/homelab/node1
docker compose up -d homepage
```

### Step 2: Access and Configure

1. Open http://192.168.1.10:3000 in your browser
2. You'll see the default Homepage interface
3. Configuration is done via YAML files in `./homepage/config/`

### Step 3: Basic Configuration Structure

Homepage uses YAML files for configuration. The directory structure should be:

```
homepage/
└── config/
    ├── services.yaml      # Your services/widgets
    ├── bookmarks.yaml     # Bookmarks
    ├── settings.yaml      # General settings
    └── docker.yaml        # Docker integration (optional)
```

### Step 4: Create Initial Configuration

Create the config directory and basic files:

```bash
mkdir -p ~/homelab/node1/homepage/config
cd ~/homelab/node1/homepage/config
```

Create `services.yaml`:

```yaml
---
# Services Configuration
# See: https://gethomepage.dev/configuration/services/

services:
  - Pterodactyl
    icon: pterodactyl.png
    href: http://192.168.1.10
    description: Game Server Management
    widget:
      type: pterodactyl
      url: http://192.168.1.10
      server: 1

  - Portainer
    icon: portainer.png
    href: http://192.168.1.10:8000
    description: Docker Management

  - Uptime Kuma
    icon: uptime-kuma.png
    href: http://192.168.1.10:3001
    description: Service Monitoring

  - Sonarr
    icon: sonarr.png
    href: http://192.168.1.11:8989
    description: TV Show Management

  - Radarr
    icon: radarr.png
    href: http://192.168.1.11:7878
    description: Movie Management

  - Lidarr
    icon: lidarr.png
    href: http://192.168.1.11:8686
    description: Music Management

  - Overseerr
    icon: overseerr.png
    href: http://192.168.1.11:5055
    description: Media Requests

  - Tautulli
    icon: tautulli.png
    href: http://192.168.1.11:8181
    description: Plex Analytics

  - Grafana
    icon: grafana.png
    href: http://192.168.1.12:3000
    description: Monitoring Dashboards
```

Create `bookmarks.yaml`:

```yaml
---
# Bookmarks Configuration
# See: https://gethomepage.dev/configuration/bookmarks/

bookmarks:
  - Homelab:
      - Pterodactyl Panel:
          - href: http://192.168.1.10
            icon: pterodactyl.png
      - Portainer:
          - href: http://192.168.1.10:8000
            icon: portainer.png
      - Uptime Kuma:
          - href: http://192.168.1.10:3001
            icon: uptime-kuma.png

  - Media:
      - Sonarr:
          - href: http://192.168.1.11:8989
            icon: sonarr.png
      - Radarr:
          - href: http://192.168.1.11:7878
            icon: radarr.png
      - Overseerr:
          - href: http://192.168.1.11:5055
            icon: overseerr.png
      - Tautulli:
          - href: http://192.168.1.11:8181
            icon: tautulli.png
```

Create `settings.yaml`:

```yaml
---
# Settings Configuration
# See: https:gethomepage.dev/configuration/settings/

title: My Homelab
description: Personal homelab dashboard
logo: /icon-512.png
favicon: /icon-512.png
theme: dark
```

### Step 5: Docker Auto-Discovery (Optional but Recommended)

Homepage can automatically discover your Docker containers. Create `docker.yaml`:

```yaml
---
# Docker Integration
# See: https://gethomepage.dev/configuration/docker/

docker:
  - name: Node 1
    url: unix:///var/run/docker.sock
    containers: [.*]
```

This will automatically discover containers on the same host. For remote nodes, you'd need to set up Docker API access.

## Widget Configuration

Homepage supports widgets for many services. Here are examples for your services:

### Tautulli Widget

```yaml
- Tautulli
  icon: tautulli.png
  href: http://192.168.1.11:8181
  widget:
    type: tautulli
    url: http://192.168.1.11:8181
    apikey: YOUR_API_KEY
```

### Plex Widget

```yaml
- Plex
  icon: plex.png
  href: http://YOUR_PLEX_SERVER:32400
  widget:
    type: plex
    url: http://YOUR_PLEX_SERVER:32400
    token: YOUR_PLEX_TOKEN
```

### Service Status Widgets

Many services support status widgets. Check the [Homepage documentation](https://gethomepage.dev/widgets/service-widgets/) for specific widget configurations.

## Tips

1. **Use Icons**: Homepage supports custom icons. Place them in `homepage/config/icons/`
2. **Organize by Category**: Group services logically (Homelab, Media, Monitoring, etc.)
3. **Use Widgets**: Widgets provide real-time information without leaving the dashboard
4. **Custom CSS**: You can customize the appearance with custom CSS
5. **Bookmarks**: Use bookmarks for quick access to external sites

## Documentation

- **Official Docs**: https://gethomepage.dev/
- **Widget Guide**: https://gethomepage.dev/widgets/service-widgets/
- **Configuration Guide**: https://gethomepage.dev/configuration/

## Example Full Configuration

See the [Homepage examples repository](https://github.com/gethomepage/homepage/tree/main/examples) for complete configuration examples.

## Restart After Configuration Changes

After editing YAML files:

```bash
docker compose restart homepage
```

Or Homepage will auto-reload changes (check logs to confirm).

## Troubleshooting

### Host Validation Failed Error

If you see errors like:
```
error: Host validation failed for: 192.168.1.88:3000. Hint: Set the HOMEPAGE_ALLOWED_HOSTS environment variable
```

**Solution:**
1. The `HOMEPAGE_ALLOWED_HOSTS` environment variable is already configured in `docker-compose.yml` with default values
2. If you're accessing from a different IP, add it to your `.env` file:
   ```bash
   HOMEPAGE_ALLOWED_HOSTS=localhost,127.0.0.1,192.168.1.10,192.168.1.88,YOUR_IP_HERE
   ```
3. Or update the `docker-compose.yml` directly to include your IP
4. Restart Homepage: `docker compose restart homepage`

**Note:** The default configuration includes common IPs (localhost, 127.0.0.1, 192.168.1.10, 192.168.1.88). If you need to add more, separate them with commas.

