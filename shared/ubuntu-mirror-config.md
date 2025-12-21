# Ubuntu Package Mirror Configuration

## Why Change the Mirror?

Since your homelab is in **London, UK**, but you're installing from **Vancouver, Canada**, the installer will detect and use a Canadian mirror (`ca.archive.ubuntu.com`). 

**Benefits of using a UK mirror**:
- Faster download speeds (closer to your servers)
- Lower latency
- Better for regular updates

## During Installation

### If Mirror Selection Screen Appears

1. **Select "Choose a different mirror"** or similar option
2. **Country**: Select **United Kingdom**
3. **Mirror**: Choose `gb.archive.ubuntu.com` or `uk.archive.ubuntu.com`
4. **Continue** with installation

**Note**: Not all Ubuntu Server installers show this screen. If you don't see it, change after installation (see below).

## After Installation (Recommended)

### Method 1: Using sed (Quick)

```bash
# Backup current sources
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Replace Canadian mirror with UK mirror
sudo sed -i 's/ca.archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list

# Update package lists
sudo apt update
```

### Method 2: Manual Edit

```bash
# Edit sources list
sudo nano /etc/apt/sources.list
```

**Find lines like**:
```
deb http://ca.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://ca.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://ca.archive.ubuntu.com/ubuntu/ jammy-security main restricted
```

**Change to**:
```
deb http://gb.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://gb.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://gb.archive.ubuntu.com/ubuntu/ jammy-security main restricted
```

**Save and update**:
```bash
sudo apt update
```

### Method 3: Using Software & Updates (GUI - if desktop installed)

1. **Open Software & Updates**
2. **Ubuntu Software tab**
3. **Download from**: Change to **United Kingdom** → **gb.archive.ubuntu.com**
4. **Close** and reload

## UK Mirror Options

### Recommended UK Mirrors

1. **gb.archive.ubuntu.com** ✅ **Recommended**
   - Official UK mirror
   - Fast and reliable
   - Best choice for London

2. **uk.archive.ubuntu.com**
   - Alternative UK mirror
   - Also official

3. **mirror.bytemark.co.uk**
   - UK-based mirror
   - Good performance

4. **mirror.ox.ac.uk**
   - Oxford University mirror
   - Very reliable

5. **mirror.coventry.ac.uk**
   - Coventry University mirror
   - Good for UK

### Finding Fastest Mirror

You can test which mirror is fastest:

```bash
# Install netselect-apt
sudo apt install netselect-apt

# Find fastest UK mirror
sudo netselect-apt -c UK -t 5 jammy

# Or test specific mirrors
curl -o /dev/null -s -w "%{time_total}\n" http://gb.archive.ubuntu.com/ubuntu/dists/jammy/Release
curl -o /dev/null -s -w "%{time_total}\n" http://uk.archive.ubuntu.com/ubuntu/dists/jammy/Release
```

## Verification

After changing mirror:

```bash
# Update package lists
sudo apt update

# Check which mirror is being used
sudo apt update 2>&1 | grep -i "http"

# Or check sources directly
cat /etc/apt/sources.list | grep -i "http"
```

**Should show**: `gb.archive.ubuntu.com` or your chosen UK mirror

## For All Three Nodes

Repeat this process on **all three nodes**:

1. **Node 1**: Change to UK mirror
2. **Node 2**: Change to UK mirror  
3. **Node 3**: Change to UK mirror

You can use the same sed command on each:

```bash
sudo sed -i 's/ca.archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt update
```

## Troubleshooting

### Mirror Not Responding

If a mirror is slow or not responding:

1. **Try different UK mirror**:
   ```bash
   sudo sed -i 's/gb.archive.ubuntu.com/uk.archive.ubuntu.com/g' /etc/apt/sources.list
   sudo apt update
   ```

2. **Use main Ubuntu archive** (fallback):
   ```bash
   sudo sed -i 's/gb.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
   sudo apt update
   ```

### Sources.list Format

**Ubuntu 22.04 (Jammy)** format:
```
deb http://gb.archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
```

**Ubuntu 24.04 (Noble)** format:
```
deb http://gb.archive.ubuntu.com/ubuntu/ noble main restricted universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ noble-updates main restricted universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ noble-backports main restricted universe multiverse
```

## Quick Reference

**Change to UK mirror**:
```bash
sudo sed -i 's/ca.archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt update
```

**Verify**:
```bash
cat /etc/apt/sources.list | grep -i "http"
```

**Recommended UK mirror**: `gb.archive.ubuntu.com`

## Is It Critical?

**Short answer**: No, but recommended.

- **During installation**: Not critical - one-time download
- **After installation**: Recommended for faster updates
- **Can change anytime**: Easy to switch mirrors later
- **Performance**: UK mirror will be faster from London

**Best practice**: Change to UK mirror after installation on all three nodes for optimal performance.

