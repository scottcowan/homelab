# New Services Setup Guide

This guide covers the setup for the newly added services.

## Tautulli (Plex Monitoring)

**Location**: Node 2  
**URL**: http://192.168.1.11:8181

### Setup Steps

1. Start the container:
   ```bash
   cd ~/homelab/node2
   docker compose up -d tautulli
   ```

2. Access the web UI at http://192.168.1.11:8181

3. Initial setup wizard will guide you:
   - Enter your Plex server URL (e.g., `http://YOUR_PLEX_SERVER:32400`)
   - Enter your Plex token (get from https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/)
   - Configure settings as needed

4. Tautulli will start monitoring your Plex server and provide analytics

### Features
- Real-time monitoring of Plex activity
- User statistics and history
- Media library statistics
- Watch time tracking
- Notifications for new content

## Ombi (Request Management)

**Location**: Node 2  
**URL**: http://192.168.1.11:3579

### Setup Steps

1. Start the container:
   ```bash
   cd ~/homelab/node2
   docker compose up -d ombi
   ```

2. Access the web UI at http://192.168.1.11:3579

3. Initial setup:
   - Create admin account
   - Configure Sonarr, Radarr, and Lidarr connections
   - Set up Plex connection
   - Configure user management

### Note
You already have Overseerr for request management. Ombi is an alternative with different features. You can use both or choose one.

## Mylar (Comic Book Management)

**Location**: Node 2  
**URL**: http://192.168.1.11:8090

### Setup Steps

1. **Create comics folder on NAS** (if not exists):
   ```bash
   # On your Synology NAS, create a "comics" shared folder
   ```

2. **Mount the folder** (if not already mounted):
   ```bash
   # Add to /etc/fstab on Node 2
   # NAS_IP:/volume1/comics /mnt/nas/comics nfs defaults 0 0
   sudo mkdir -p /mnt/nas/comics
   sudo mount -a
   ```

3. Start the container:
   ```bash
   cd ~/homelab/node2
   docker compose up -d mylar
   ```

4. Access the web UI at http://192.168.1.11:8090

5. Configure:
   - Connect to Prowlarr for indexers
   - Connect to qBittorrent for downloads
   - Set download and comic storage paths
   - Add comic series to track

## UniFi Controller

**Location**: Node 1  
**URL**: https://192.168.1.10:8443

### Setup Steps

1. Start the container:
   ```bash
   cd ~/homelab/node1
   docker compose up -d unifi
   ```

2. Wait for initialization (may take a few minutes)

3. Access the web UI at https://192.168.1.10:8443

4. Initial setup:
   - Accept the self-signed certificate warning
   - Create admin account
   - Configure your UniFi network devices

### Important Notes

- **Ports**: UniFi uses many ports. The docker-compose includes the most common ones
- **Adoption**: Your UniFi devices need to be able to reach the controller
- **Backup**: Regularly backup the UniFi config directory (`./unifi`)
- **Updates**: UniFi controller updates can be disruptive - test in non-production first

### Ports Used
- 8443: Web UI (HTTPS)
- 3478: STUN
- 10001: AP discovery
- 8080: Device communication
- 1900: L2 network discovery
- 8843: HTTPS portal redirect
- 8880: HTTP portal redirect
- 6789: Mobile speed test
- 5514: Remote syslog

## OctoPrint (3D Printer Management)

**Location**: Node 3  
**URL**: http://192.168.1.12:5000

### Setup Steps

1. **Identify your printer's USB device**:
   ```bash
   # Plug in your 3D printer via USB
   ls -la /dev/tty* | grep USB
   # Common devices: /dev/ttyUSB0, /dev/ttyACM0
   ```

2. **Update docker-compose.yml** with your printer's device:
   ```yaml
   devices:
     - /dev/ttyUSB0:/dev/ttyUSB0  # Change to your device
   ```

3. **If using a USB webcam**, identify the device:
   ```bash
   ls -la /dev/video*
   # Usually /dev/video0
   ```

4. Start the container:
   ```bash
   cd ~/homelab/node3
   docker compose up -d octoprint
   ```

5. Access the web UI at http://192.168.1.12:5000

6. Initial setup:
   - Create admin account
   - Connect to your 3D printer
   - Configure printer settings
   - Install plugins as needed

### Important Notes

- **USB Access**: OctoPrint needs privileged access to USB devices
- **Device Path**: Update the device path in docker-compose.yml to match your printer
- **Webcam**: If using a USB webcam, uncomment the video device line
- **Network Access**: For network printers, you may need different configuration

### Troubleshooting

If OctoPrint can't see your printer:
1. Check device permissions: `ls -la /dev/ttyUSB0`
2. Add your user to dialout group: `sudo usermod -aG dialout $USER`
3. Check container logs: `docker compose logs octoprint`
4. Verify device is accessible: `docker compose exec octoprint ls -la /dev/ttyUSB0`

## Homepage (Landing Page)

**Location**: Node 1  
**URL**: http://192.168.1.10:3000

See `shared/homepage-setup.md` for detailed Homepage configuration.

### Quick Start

1. Start the container:
   ```bash
   cd ~/homelab/node1
   docker compose up -d homepage
   ```

2. Access at http://192.168.1.10:3000

3. Configure by editing YAML files in `./homepage/config/`

## Resource Usage Summary

### New Services RAM Usage
- Homepage: ~128MB
- UniFi Controller: ~512MB
- Tautulli: ~256MB
- Ombi: ~256MB
- Mylar: ~256MB
- OctoPrint: ~256MB

**Total Additional**: ~1.7GB

Make sure you have enough RAM available on each node before starting all services.

