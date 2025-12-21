# Ubuntu Installation Guide - Creating Bootable USB from Windows

## Tools Needed

### Option 1: Rufus (Recommended for Windows)

**Rufus** is the most popular and reliable tool for creating bootable USB drives on Windows.

- **Download**: https://rufus.ie/
- **Version**: Latest (3.x or 4.x)
- **Type**: Portable (no installation needed)
- **Why**: Fast, reliable, handles UEFI/BIOS, supports GPT/MBR

### Option 2: Balena Etcher (Alternative)

**Balena Etcher** is user-friendly and cross-platform.

- **Download**: https://etcher.balena.io/
- **Version**: Latest
- **Type**: Installer or portable
- **Why**: Simple interface, works on Windows/Mac/Linux

### Option 3: Ventoy (Advanced - Multiple ISOs)

**Ventoy** allows you to put multiple ISO files on one USB drive.

- **Download**: https://www.ventoy.net/
- **Why**: Can boot multiple operating systems from one USB

## Recommended: Rufus Setup

### Step 1: Download Ubuntu Server ISO

1. Go to https://ubuntu.com/download/server
2. Download **Ubuntu Server 22.04 LTS** or **24.04 LTS**
   - Choose the LTS (Long Term Support) version
   - File will be ~5-6GB, named something like `ubuntu-22.04.x-live-server-amd64.iso`

### Step 2: Download Rufus

1. Go to https://rufus.ie/
2. Download the latest version (portable is fine)
3. No installation needed - just run the `.exe` file

### Step 3: Prepare USB Drive

1. **Insert USB drive** (minimum 8GB, 16GB recommended)
2. **Backup any data** - Rufus will erase everything on the USB
3. **Format**: USB will be formatted, so backup important files first

### Step 4: Create Bootable USB with Rufus

1. **Run Rufus** (may need to run as Administrator)

2. **Device**: Select your USB drive from the dropdown
   - ⚠️ **Double-check** you selected the correct drive!

3. **Boot selection**: Click **SELECT** and choose your downloaded Ubuntu ISO file

4. **Partition scheme**: 
   - **GPT** ✅ **Choose this** (required for UEFI systems)
   - **MBR** (only for Legacy/BIOS systems - not recommended)
   - **Dell Optiplex 9020M supports UEFI**, so use **GPT**
   - GPT is required because we're using UEFI boot mode in BIOS

5. **Target system**: 
   - **UEFI (non CSM)** ✅ **Choose this** (for Dell Optiplex 9020M)
   - **BIOS or UEFI-CSM** (only if UEFI doesn't work - unlikely)
   - Must match the GPT partition scheme above

6. **Volume label**: Will auto-fill (can leave as is)

7. **File system**: **FAT32** (default, recommended)

8. **Cluster size**: **4096 bytes** (default)

9. **Click START**

10. **Warning dialogs**:
    - "All data on device will be destroyed" - Click **OK**
    - "Download required" (if needed) - Click **Yes**
    - "Write in ISO Image mode?" - Click **OK** (recommended)

11. **Wait for completion** (5-15 minutes depending on USB speed)

12. **Status**: Will show "READY" when complete

13. **Close Rufus** and safely eject USB

## Alternative: Balena Etcher Setup

### Step 1: Download Ubuntu ISO
- Same as above - get Ubuntu Server 22.04 LTS or 24.04 LTS

### Step 2: Download Balena Etcher
- Download from https://etcher.balena.io/
- Install or use portable version

### Step 3: Create Bootable USB

1. **Open Balena Etcher**

2. **Flash from file**: Click and select your Ubuntu ISO

3. **Select target**: Choose your USB drive
   - ⚠️ **Double-check** the correct drive!

4. **Click Flash!**

5. **Wait for completion** (shows progress)

6. **Done!** Safely eject USB

## Verification

Before installing, verify the USB works:

1. **Insert USB** into the target machine (Dell Optiplex 9020M)
2. **Boot from USB**:
   - Power on the machine
   - Press **F12** (Dell boot menu) or **F2** (BIOS setup)
   - Select USB drive from boot menu
3. **Ubuntu installer should start**

## BIOS Update (Recommended Before Installation)

**Important**: Update BIOS to latest version before installing Ubuntu for best compatibility.

See `shared/bios-update-dell-9020m.md` for detailed instructions.

**Quick method** (if Windows is still installed):
1. Go to https://www.dell.com/support
2. Enter your Service Tag (found on machine sticker)
3. Download latest BIOS update
4. Run the .exe file as Administrator
5. Follow prompts and wait for completion

## BIOS Settings for Dell Optiplex 9020M

**Important**: Configure BIOS **BEFORE** booting from USB for best results.

### Accessing BIOS

1. **Power on** the Dell Optiplex 9020M
2. **Press F2** repeatedly during boot (before Windows/Dell logo appears)
3. **Alternative**: Press **F12** for boot menu (one-time boot selection)

### Recommended BIOS Settings

#### 1. Boot Configuration

- **Boot Mode**: **UEFI** (not Legacy/CSM)
  - Path: `Boot` → `Boot Mode` → Select **UEFI**
  - Modern Ubuntu works best with UEFI

- **Boot Sequence**:
  - Path: `Boot` → `Boot Sequence`
  - Move **USB Storage Device** to top of list
  - Or use **F12** boot menu to select USB one-time

- **Secure Boot**: **Disabled** (recommended for Ubuntu)
  - Path: `Security` → `Secure Boot` → **Disabled**
  - Ubuntu can work with Secure Boot, but disabling is easier

#### 2. Storage Configuration

- **SATA Operation**: **AHCI** (not RAID or IDE)
  - Path: `System Configuration` → `SATA Operation` → **AHCI**
  - Required for proper disk detection in Ubuntu

- **Hard Drive**: Ensure internal drive is enabled
  - Path: `System Configuration` → `Drives`
  - Verify 500GB drive is listed and enabled

#### 3. USB Configuration

- **USB Controller**: **Enabled**
  - Path: `System Configuration` → `USB Configuration`
  - Ensure USB ports are enabled

- **USB Boot Support**: **Enabled**
  - Should be enabled by default

#### 4. Virtualization (Optional - for future use)

- **Virtualization Technology (VT-x)**: **Enabled**
  - Path: `System Configuration` → `Virtualization`
  - Useful if you want to run VMs later

- **VT-d (IOMMU)**: **Enabled** (if available)
  - For advanced virtualization features

#### 5. Power Management

- **Wake on LAN**: **Enabled** (if you want remote wake)
  - Path: `Power Management` → `Wake on LAN`
  - Useful for remote management

- **AC Recovery**: **Power On** (optional)
  - Automatically powers on after power loss
  - Useful for homelab servers

#### 6. Security Settings

- **Set Supervisor Password**: **Recommended**
  - Prevents unauthorized BIOS changes
  - Path: `Security` → `Set Supervisor Password`

- **TPM**: **Enabled** (if available)
  - For security features (can be used later)

### BIOS Settings Summary Checklist

Before installing Ubuntu:

- [ ] Boot Mode: **UEFI**
- [ ] Secure Boot: **Disabled**
- [ ] SATA Operation: **AHCI**
- [ ] USB Controller: **Enabled**
- [ ] USB Boot: **Enabled**
- [ ] Boot Sequence: USB first (or use F12 menu)
- [ ] Virtualization: **Enabled** (optional)
- [ ] Supervisor Password: Set (recommended)

### Saving BIOS Settings

1. **Press F10** to save and exit
2. **Or**: Go to `Exit` → `Save Changes and Exit`
3. **Confirm**: Select **Yes**
4. System will reboot

### Booting from USB

After BIOS is configured:

1. **Insert USB** drive
2. **Power on** machine
3. **Press F12** during boot (Dell boot menu)
4. **Select USB drive** from menu
5. **Ubuntu installer** should start

### If USB Doesn't Boot

1. **Check USB is detected**: 
   - Enter BIOS (F2)
   - Check `Boot` → `Boot Sequence`
   - USB should appear in list

2. **Try different USB port**:
   - Use USB 2.0 port (usually black, not blue)
   - Front panel ports sometimes work better

3. **Recreate USB**:
   - Try Rufus with **MBR** instead of GPT
   - Or try **BIOS or UEFI-CSM** mode

4. **Check USB drive**:
   - Try different USB drive
   - Some drives have compatibility issues

5. **Legacy Boot** (last resort):
   - Change Boot Mode to **Legacy**
   - Recreate USB with MBR partition scheme

### During Installation

1. **Language**: English

2. **Keyboard**: UK layout (since homelab is in London)

3. **Base Installation Selection**:
   - **Choose: "Ubuntu Server"** (not minimized)
   - **Why**: Includes more tools and utilities out of the box
   - **Minimized**: Only if you want absolute minimum (not recommended for homelab)
   - **Server**: Recommended - includes useful tools for setup and management

4. **Third-Party Drivers**:
   - ✅ **Check the box** "Install third-party drivers for graphics and Wi-Fi hardware"
   - **Why**: Your TP-Link WiFi dongle may need proprietary drivers
   - This will help detect and configure your WiFi adapter during installation
   - Even though you'll use wired later, this ensures WiFi works during setup

5. **Network Configuration**:
   - **Initial Setup**: Choose **DHCP** (automatic)
   - **Why**: Easier during initial setup, especially with WiFi
   - **After Installation**: Change to static IP (see Post-Installation section)
   - **WiFi Setup**: 
     - Select your TP-Link WiFi adapter
     - Enter your WiFi network name (SSID)
     - Enter WiFi password
     - Connection will be established automatically

6. **Storage**: Use entire disk (500GB)
   - **Partitioning**: Guided - use entire disk
   - **LVM**: ✅ **Use LVM** (Logical Volume Management) - recommended for flexibility
   - **LUKS Encryption**: ❌ **Do NOT encrypt** (choose "No" or leave unchecked)
     - **Why skip encryption**:
       - Performance overhead (slower disk I/O)
       - Complexity in recovery/maintenance
       - Not necessary for homelab (physical security usually sufficient)
       - Can cause issues with remote reboots
       - Makes disk management more complex
     - **When you WOULD use encryption**:
       - Laptops or portable devices
       - Sensitive data requiring compliance
       - Multi-tenant environments
     - **For homelab**: Physical security (locked room/rack) is usually sufficient

7. **Profile Setup** (User Account Configuration):
   
   **Your name**: 
   - Full name (e.g., "Scott Cowan" or "Homelab Admin")
   - This is just a display name, can be anything
   
   **Server name**:
   - **Node 1**: `node1` or `homelab-node1` or `pterodactyl-panel`
   - **Node 2**: `node2` or `homelab-node2` or `wings-servarr`
   - **Node 3**: `node3` or `homelab-node3` or `services`
   - **Recommendation**: Use simple names like `node1`, `node2`, `node3`
   - **Note**: This is the hostname, can be changed later with `sudo hostnamectl set-hostname newname`
   
   **Username**:
   - Choose something memorable (e.g., `admin`, `homelab`, `scott`)
   - **Recommendation**: Use the same username on all 3 nodes for consistency
   - **Rules**: Lowercase, no spaces, can use letters/numbers/dashes/underscores
   - **Examples**: `admin`, `homelab`, `scott`, `user`
   
   **Password**:
   - **Use a strong password** (minimum 8 characters, mix of letters/numbers/symbols)
   - **Recommendation**: Use a password manager to generate and store
   - **Important**: You'll need this for sudo commands and SSH login
   - **Security tip**: Consider using SSH keys later (disable password auth)
   - **Same password?**: You can use the same password on all nodes, or different ones
   
   **Confirm password**: Enter the same password again

8. **SSH**: ✅ **Enable SSH server** (important!)
   - **Install OpenSSH server**: Check this box
   - Allows remote access from your Windows machine

9. **Snaps**: **Skip** (you're using Docker for all services, snaps not needed)

10. **Updates**: Install security updates during installation
    - **Download updates**: Yes (if internet connection is available)
    - **Install security updates**: Yes

11. **Package Mirror** (Optional but Recommended):
    - **During installation**: You may see a mirror selection screen
    - **Current**: `ca.archive.ubuntu.com` (Canadian mirror - detected automatically)
    - **Recommended**: Change to UK mirror since homelab will be in London
    - **UK Mirror**: `gb.archive.ubuntu.com` or `uk.archive.ubuntu.com`
    - **Or**: Leave as-is and change after installation (see Post-Installation)
    - **Note**: Not critical during installation, can be changed easily later

### Post-Installation

1. **Update system**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Change Package Mirror to UK** (Recommended):

   Since your homelab is in London, use a UK mirror for faster updates:

   ```bash
   # Backup current sources
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
   
   # Replace Canadian mirror with UK mirror
   sudo sed -i 's/ca.archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
   sudo sed -i 's/archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
   
   # Update package lists
   sudo apt update
   ```

   **See `shared/ubuntu-mirror-config.md`** for detailed instructions and alternative UK mirrors.

3. **Set timezone**:
   ```bash
   sudo timedatectl set-timezone Europe/London
   ```

3. **Change Package Mirror to UK** (Recommended):

   Since your homelab is in London, use a UK mirror for faster updates:

   ```bash
   # Backup current sources
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
   
   # Edit sources list
   sudo nano /etc/apt/sources.list
   ```

   **Replace** `ca.archive.ubuntu.com` with `gb.archive.ubuntu.com`:
   ```bash
   # Find and replace (or edit manually)
   sudo sed -i 's/ca.archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
   sudo sed -i 's/archive.ubuntu.com/gb.archive.ubuntu.com/g' /etc/apt/sources.list
   ```

   **Or manually edit** `/etc/apt/sources.list`:
   ```
   # Change from:
   deb http://ca.archive.ubuntu.com/ubuntu/ jammy main restricted
   
   # To:
   deb http://gb.archive.ubuntu.com/ubuntu/ jammy main restricted
   ```

   **Update package lists**:
   ```bash
   sudo apt update
   ```

   **Alternative UK mirrors**:
   - `gb.archive.ubuntu.com` (UK mirror - recommended)
   - `uk.archive.ubuntu.com` (Alternative UK mirror)
   - `mirror.bytemark.co.uk` (UK mirror)
   - `mirror.ox.ac.uk` (Oxford University, UK)

5. **Configure Static IP** (Change from DHCP to Static):

   **Option A: Using netplan (Ubuntu 18.04+)**

   ```bash
   # Edit network configuration
   sudo nano /etc/netplan/00-installer-config.yaml
   ```

   **For wired connection** (when you connect Ethernet):
   ```yaml
   network:
     version: 2
     renderer: networkd
     ethernets:
       enp0s3:  # Replace with your interface name (check with: ip addr)
         dhcp4: false
         addresses:
           - 192.168.1.10/24  # Use .11 for Node 2, .12 for Node 3
         routes:
           - to: default
             via: 192.168.1.1  # Your router IP
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

   **Option B: Using NetworkManager (if installed)**

   ```bash
   # Check interface name
   ip addr show
   
   # Configure static IP
   sudo nmcli connection modify "Wired connection 1" \
     ipv4.addresses 192.168.1.10/24 \
     ipv4.gateway 192.168.1.1 \
     ipv4.dns "8.8.8.8 8.8.4.4" \
     ipv4.method manual
   
   # Restart network
   sudo nmcli connection down "Wired connection 1"
   sudo nmcli connection up "Wired connection 1"
   ```

4. **Find your network interface name**:
   ```bash
   # List all interfaces
   ip addr show
   
   # Or
   ls /sys/class/net/
   
   # Common names:
   # - enp0s3, enp0s8 (Ethernet)
   # - wlp2s0, wlan0 (WiFi)
   ```

5. **Disable WiFi** (after connecting Ethernet, optional):
   ```bash
   # Check WiFi interface
   ip addr show
   
   # Disable WiFi (if you want)
   sudo nmcli radio wifi off
   
   # Or disable the WiFi interface
   sudo ip link set wlan0 down  # Replace wlan0 with your WiFi interface
   ```

6. **Verify network**:
   ```bash
   ip addr show
   ping -c 3 8.8.8.8
   ping -c 3 192.168.1.1  # Your router
   ```

7. **Test SSH access** (from your Windows machine):
   ```bash
   # From Windows PowerShell or Command Prompt
   ssh username@192.168.1.10
   ```

## Troubleshooting

### USB Not Booting

1. **Check USB format**: Should be FAT32
2. **Try different USB port**: Use USB 2.0 port if available
3. **Check BIOS settings**: Ensure USB boot is enabled
4. **Try different USB drive**: Some drives have compatibility issues
5. **Recreate USB**: Try Rufus again with different settings

### Rufus Errors

- **"Access Denied"**: Run Rufus as Administrator
- **"Device is busy"**: Close all file explorer windows, unmount USB
- **"ISO not found"**: Re-download Ubuntu ISO, check file integrity

### Installation Issues

- **"No network"**: Configure network manually during installation
- **"Can't find disk"**: Check SATA mode in BIOS (AHCI recommended)
- **"Installation freezes"**: Try different USB port, check hardware

## Quick Checklist

- [ ] USB drive (8GB+)
- [ ] Ubuntu Server ISO downloaded
- [ ] Rufus or Balena Etcher downloaded
- [ ] USB created successfully
- [ ] Tested boot on target machine
- [ ] BIOS configured correctly
- [ ] Installation completed
- [ ] SSH enabled
- [ ] Static IP configured
- [ ] Timezone set to Europe/London

## Resources

- **Ubuntu Server Download**: https://ubuntu.com/download/server
- **Rufus**: https://rufus.ie/
- **Balena Etcher**: https://etcher.balena.io/
- **Ubuntu Installation Guide**: https://ubuntu.com/server/docs/installation

## Next Steps After Installation

Once Ubuntu is installed on all 3 machines:

1. Follow `shared/node1-first-setup.md` for Node 1
2. Set up SSH access from your Windows machine
3. Install Docker and Docker Compose
4. Deploy your homelab services

Good luck with your installation! 🚀

