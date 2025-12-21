# Storage Options for Node 2 - Managing Download Storage

## Current Setup (Good News!)

Your current configuration **already downloads to your NAS**, which is the best approach:

```yaml
volumes:
  - /mnt/nas/downloads:/downloads  # Downloads go to NAS, not local drive
```

This means:
- ✅ Downloads don't fill up your local 500GB drive
- ✅ Media is stored on your NAS (more space, centralized)
- ✅ Sonarr/Radarr can move files directly from NAS to NAS

## Storage Strategy Options

### Option 1: Keep Using NAS (Recommended - Already Configured)

**Pros:**
- No hardware changes needed
- Centralized storage
- Easy to expand (just add drives to NAS)
- Better for media library management

**Cons:**
- Network speed depends on your NAS and network
- If NAS is slow, downloads might be slower

**Action Required:** None! This is already set up.

### Option 2: Add Second Drive to Node 2

If you want faster downloads or want to keep downloads separate from your NAS:

#### A. Replace Internal Drive (Best Performance)

**Dell Optiplex 9020M Micro supports:**
- 1x 2.5" SATA drive (currently 500GB)
- Can replace with 1TB, 2TB, or 4TB 2.5" SSD

**Steps:**
1. Backup current system
2. Replace drive with larger one
3. Reinstall Ubuntu Server
4. Restore your configuration

#### B. Add USB 3.0 External Drive (Easiest)

**Pros:**
- No disassembly needed
- Can use any size USB drive
- Easy to move/backup

**Cons:**
- Slightly slower than internal SATA
- USB port required

**Steps:**
1. Connect USB 3.0 external drive
2. Format and mount it
3. Update docker-compose to use it

### Option 3: Hybrid Approach (Recommended if Adding Drive)

Use local drive for **active downloads**, NAS for **completed media**:

- **Local drive**: Temporary downloads, incomplete files
- **NAS**: Completed movies/TV shows, music library

This gives you:
- Fast downloads to local drive
- Automatic cleanup (Sonarr/Radarr moves completed files to NAS)
- Local drive never fills up (completed files moved away)

## Implementation Guide

### If You Want to Use a Local Drive (Option 2 or 3)

#### Step 1: Add and Format the Drive

```bash
# List all disks
lsblk

# Find your new drive (e.g., /dev/sdb)
sudo fdisk -l

# Format the drive (replace /dev/sdb with your drive)
sudo fdisk /dev/sdb
# In fdisk: n (new partition), p (primary), Enter (defaults), w (write)

# Format as ext4
sudo mkfs.ext4 /dev/sdb1

# Create mount point
sudo mkdir -p /mnt/downloads

# Mount the drive
sudo mount /dev/sdb1 /mnt/downloads

# Make it permanent (add to /etc/fstab)
echo "/dev/sdb1 /mnt/downloads ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Set permissions
sudo chown -R $USER:$USER /mnt/downloads
```

#### Step 2: Update docker-compose.yml

Update Node 2's docker-compose to use local drive:

```yaml
qbittorrent:
  volumes:
    - ./qbittorrent:/config
    - /mnt/downloads:/downloads  # Local drive instead of NAS
```

#### Step 3: Configure qBittorrent for Hybrid Approach

In qBittorrent settings:
- **Default Save Path**: `/downloads/incomplete` (local drive)
- **Completed Downloads**: Configure Sonarr/Radarr to move to NAS after completion

### If Using Hybrid Approach (Option 3)

Update docker-compose to have both:

```yaml
qbittorrent:
  volumes:
    - ./qbittorrent:/config
    - /mnt/downloads:/downloads  # Local drive for active downloads
    - /mnt/nas/downloads:/downloads-complete  # NAS for completed (optional)
```

Then configure:
- **qBittorrent**: Download to `/downloads` (local)
- **Sonarr/Radarr**: Import from `/downloads`, move to `/mnt/nas/tv` or `/mnt/nas/movies` (NAS)

## Monitoring Storage

### Check Disk Usage

```bash
# Check local drive usage
df -h /

# Check NAS mount usage
df -h /mnt/nas

# Check specific directory sizes
du -sh /mnt/downloads/*
du -sh /mnt/nas/downloads/*
```

### Set Up Alerts

Add to Uptime Kuma or create a simple script:

```bash
#!/bin/bash
# Check disk usage and alert if > 80%
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $USAGE -gt 80 ]; then
    echo "Warning: Disk usage is ${USAGE}%"
    # Send notification (email, Discord, etc.)
fi
```

## qBittorrent Storage Management

### Configure Automatic Cleanup

In qBittorrent (Settings → Downloads):
- ✅ **Delete .torrent files after successful download**
- ✅ **Delete .torrent files after failed download**
- ✅ **Pre-allocate disk space** (prevents fragmentation)

### Set Download Limits

- **Maximum active downloads**: 3-5 (prevents overwhelming storage)
- **Maximum active uploads**: 3-5
- **Maximum ratio**: 1.0 (auto-remove after seeding)

### Configure Categories

Set up categories with different storage locations:
- **Movies**: `/downloads/movies` → Auto-move to NAS when complete
- **TV**: `/downloads/tv` → Auto-move to NAS when complete
- **Music**: `/downloads/music` → Auto-move to NAS when complete

## Recommended Configuration

For your setup, I recommend:

1. **Keep using NAS for downloads** (current setup) - It's already configured and works well
2. **Monitor storage** - Set up alerts if NAS gets full
3. **Configure Sonarr/Radarr** - Set them to delete original files after import (saves space)
4. **If you add a drive** - Use it for Docker volumes and Pterodactyl game servers instead

## Updating docker-compose.yml

If you decide to use a local drive, I can update the docker-compose file. Just let me know:
- Do you want to add a USB drive?
- Do you want to replace the internal drive?
- Do you want to use hybrid approach (local for downloads, NAS for media)?

## Quick Reference

**Current Setup:**
- Downloads: `/mnt/nas/downloads` (NAS)
- TV Shows: `/mnt/nas/tv` (NAS)
- Movies: `/mnt/nas/movies` (NAS)
- Music: `/mnt/nas/music` (NAS)

**If Adding Local Drive:**
- Downloads: `/mnt/downloads` (local)
- TV Shows: `/mnt/nas/tv` (NAS - after Sonarr moves them)
- Movies: `/mnt/nas/movies` (NAS - after Radarr moves them)
- Music: `/mnt/nas/music` (NAS - after Lidarr moves them)

