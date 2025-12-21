# Ubuntu Snaps for Homelab - Installation Guide

## Recommendation: Skip Snaps During Installation

For your homelab setup, **skip installing additional snaps** during Ubuntu Server installation.

## Why Skip Snaps?

### You're Using Docker

- **All services in Docker**: Your entire homelab runs in Docker containers
- **No need for snaps**: Services like Sonarr, Radarr, Plex, etc. are in Docker
- **Snaps vs Docker**: Snaps are another containerization method - you don't need both

### Potential Conflicts

- **Resource usage**: Snaps can use additional resources
- **Disk space**: Each snap includes its own dependencies
- **Management**: Two container systems (Docker + Snaps) = more complexity
- **Updates**: Different update mechanisms

### Can Install Later

- **Easy to add**: Snaps can be installed anytime with `snap install`
- **No rush**: Install only what you actually need
- **Better control**: Choose specific snaps based on actual requirements

## What Snaps Are Installed by Default?

Ubuntu Server installs some core snaps automatically:
- **core**: Core snap utilities (required)
- **snapd**: Snap daemon (required)

**These are fine** - they're minimal and necessary for the snap system.

## Useful Snaps (Install Later If Needed)

### SSL Certificates

**certbot** - For Let's Encrypt SSL certificates:

```bash
# Install via snap (recommended method)
sudo snap install --classic certbot

# Or install via apt (alternative)
sudo apt install certbot
```

**When to use**: If you want SSL certificates for your services (Pterodactyl Panel, Homepage, etc.)

### Container Management

**lxd** - LXD container manager:

```bash
sudo snap install lxd
```

**When to use**: If you want system containers (different from Docker application containers). Probably not needed since you're using Docker.

### Kubernetes (Advanced)

**microk8s** - Lightweight Kubernetes:

```bash
sudo snap install microk8s --classic
```

**When to use**: If you want to run Kubernetes instead of Docker. Probably overkill for your setup.

### Other Potentially Useful Snaps

**nextcloud** - File sync (but you're not using it):
```bash
sudo snap install nextcloud
```
**Note**: You have Nextcloud commented out in Docker, so probably not needed.

**rocketchat** - Team chat (if needed):
```bash
sudo snap install rocketchat-server
```

## Installation Screen Choice

During Ubuntu Server installation:

**Snaps selection**:
- ✅ **Skip/None** - Recommended
- ✅ **Minimal** - If you want just core snaps
- ❌ **Full selection** - Not recommended (installs many unnecessary snaps)

**Best choice**: **Skip** or select **None/Minimal**

## Installing Snaps Later

If you need a snap later:

```bash
# Search for snaps
snap find searchterm

# Install a snap
sudo snap install snapname

# List installed snaps
snap list

# Remove a snap
sudo snap remove snapname
```

## Managing Snaps

### View Installed Snaps

```bash
snap list
```

### Update Snaps

```bash
# Update all snaps
sudo snap refresh

# Update specific snap
sudo snap refresh snapname
```

### Remove Unused Snaps

```bash
# Remove a snap
sudo snap remove snapname

# Remove and purge data
sudo snap remove --purge snapname
```

## Snaps vs Docker vs APT

### When to Use Each

**Docker** ✅ (Your primary method):
- Application containers (Sonarr, Radarr, Plex, etc.)
- Service isolation
- Easy management with docker-compose
- **This is what you're using**

**APT** ✅ (System packages):
- System utilities (Docker, curl, git, etc.)
- Development tools
- System dependencies
- **Use for system-level packages**

**Snaps** ⚠️ (Optional):
- Some applications (certbot, lxd)
- Applications that work better as snaps
- **Use sparingly, only if needed**

## Recommendation Summary

**During Installation**:
- ✅ **Skip snaps** or choose **Minimal/None**
- ✅ Focus on getting Ubuntu Server installed
- ✅ Install Docker via apt (not snap)

**After Installation**:
- ✅ Install Docker via apt: `sudo apt install docker.io docker-compose-plugin`
- ✅ Use Docker for all services
- ✅ Install specific snaps only if you actually need them

## Quick Answer

**Skip snaps during installation** - you don't need them for your homelab setup since everything runs in Docker.

If you need something later (like certbot for SSL), you can install it then:
```bash
sudo snap install --classic certbot
```

But for now, **skip the snaps selection** and proceed with installation.

