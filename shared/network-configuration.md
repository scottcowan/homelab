# Network Configuration Guide

## Initial Setup (During Installation)

### WiFi Setup (Temporary)

During Ubuntu Server installation:

1. **Select WiFi adapter**: Choose your TP-Link WiFi dongle
2. **Enter SSID**: Your WiFi network name
3. **Enter password**: Your WiFi password
4. **Connection**: Will be established automatically
5. **IP**: Will get IP via DHCP automatically

### Installation Network Options

- **Base**: Choose **"Ubuntu Server"** (not minimized)
- **Third-party drivers**: ✅ **Enable** (for WiFi dongle support)
- **Network**: Use **DHCP** initially (easier setup)

## Post-Installation: Change to Static IP

### Step 1: Find Your Network Interface

```bash
# List all network interfaces
ip addr show

# Common interface names:
# - enp0s3, enp0s8, eth0 (Ethernet)
# - wlp2s0, wlan0 (WiFi)
```

### Step 2: Configure Static IP with netplan

**Edit netplan configuration**:

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

**For Node 1 (192.168.1.10)**:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:  # Replace with your actual interface name
      dhcp4: false
      addresses:
        - 192.168.1.10/24
      routes:
        - to: default
          via: 192.168.1.1  # Your router IP
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

**For Node 2 (192.168.1.11)**:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:  # Replace with your actual interface name
      dhcp4: false
      addresses:
        - 192.168.1.11/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

**For Node 3 (192.168.1.12)**:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:  # Replace with your actual interface name
      dhcp4: false
      addresses:
        - 192.168.1.12/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

**Apply changes**:
```bash
sudo netplan apply
```

**Verify**:
```bash
ip addr show
ping -c 3 8.8.8.8
```

### Step 3: Find Your Router IP

If you don't know your router IP:

```bash
# Check current gateway
ip route | grep default

# Or
route -n

# Common router IPs:
# - 192.168.1.1
# - 192.168.0.1
# - 10.0.0.1
```

### Step 4: Test Connectivity

```bash
# Test internet
ping -c 3 8.8.8.8

# Test router
ping -c 3 192.168.1.1

# Test DNS
nslookup google.com
```

## Switching from WiFi to Ethernet

### When You Connect Ethernet Cable

1. **Connect Ethernet cable** to the machine
2. **Check new interface**:
   ```bash
   ip addr show
   ```
3. **Update netplan** to use Ethernet interface instead of WiFi
4. **Apply changes**:
   ```bash
   sudo netplan apply
   ```

### Disable WiFi (Optional)

After Ethernet is working:

```bash
# Disable WiFi radio
sudo nmcli radio wifi off

# Or disable WiFi interface
sudo ip link set wlan0 down  # Replace wlan0 with your WiFi interface

# To re-enable later:
sudo nmcli radio wifi on
# or
sudo ip link set wlan0 up
```

## Troubleshooting

### Can't Connect After Static IP Change

1. **Check interface name** is correct:
   ```bash
   ip addr show
   ```

2. **Check netplan syntax**:
   ```bash
   sudo netplan --debug apply
   ```

3. **Verify router IP** is correct:
   ```bash
   ip route | grep default
   ```

4. **Test with DHCP again** (temporarily):
   ```yaml
   network:
     version: 2
     renderer: networkd
     ethernets:
       enp0s3:
         dhcp4: true
   ```
   ```bash
   sudo netplan apply
   ```

### WiFi Not Working

1. **Check WiFi adapter is detected**:
   ```bash
   lsusb | grep -i tp-link
   # or
   lspci | grep -i network
   ```

2. **Check WiFi interface**:
   ```bash
   ip addr show
   ```

3. **Check WiFi is enabled**:
   ```bash
   sudo nmcli radio wifi on
   ```

4. **Scan for networks**:
   ```bash
   sudo iwlist wlan0 scan  # Replace wlan0 with your interface
   ```

5. **Reinstall WiFi drivers** (if needed):
   ```bash
   sudo apt update
   sudo apt install linux-firmware
   ```

### Interface Name Changed After Reboot

If interface name changes (e.g., enp0s3 → enp0s4):

1. **Use MAC address** in netplan (more reliable):
   ```yaml
   network:
     version: 2
     renderer: networkd
     ethernets:
       match:
         macaddress: aa:bb:cc:dd:ee:ff  # Your interface MAC
       set-name: enp0s3
       dhcp4: false
       addresses:
         - 192.168.1.10/24
       routes:
         - to: default
           via: 192.168.1.1
       nameservers:
         addresses:
           - 8.8.8.8
           - 8.8.4.4
   ```

2. **Find MAC address**:
   ```bash
   ip addr show
   # Look for "link/ether" line
   ```

## Quick Reference

### Installation Choices

- **Base**: Ubuntu Server (not minimized)
- **Third-party drivers**: ✅ Enable (for WiFi)
- **Network**: DHCP initially

### Static IP Configuration

**Node 1**: 192.168.1.10
**Node 2**: 192.168.1.11
**Node 3**: 192.168.1.12

**Gateway**: 192.168.1.1 (or your router IP)
**DNS**: 8.8.8.8, 8.8.4.4

### Commands

```bash
# View interfaces
ip addr show

# View routes
ip route

# Test connectivity
ping -c 3 8.8.8.8

# Apply netplan
sudo netplan apply

# Check netplan
sudo netplan --debug apply
```

## Next Steps

After network is configured:

1. **Test SSH access** from your Windows machine
2. **Continue with homelab setup** (see `node1-first-setup.md`)
3. **Configure NFS mounts** (if using NAS)
4. **Deploy Docker services**

