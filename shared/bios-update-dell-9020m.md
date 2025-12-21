# BIOS Update Guide - Dell Optiplex 9020M

Updating the BIOS to the latest version is recommended for:
- Security patches
- Hardware compatibility improvements
- Bug fixes
- Better Ubuntu support

## Finding Your Current BIOS Version

### Method 1: Check in BIOS

1. **Power on** the Dell Optiplex 9020M
2. **Press F2** to enter BIOS
3. **Look at main screen** - BIOS version is displayed (e.g., "A25", "A28")
4. **Note the version** for reference

### Method 2: Check in Windows (if still installed)

1. **Open Command Prompt** (Run as Administrator)
2. **Run**: `wmic bios get smbiosbiosversion`
3. **Or**: `systeminfo | findstr /B /C:"BIOS Version"`

### Method 3: Check in Ubuntu (after installation)

```bash
sudo dmidecode -s bios-version
```

## Finding BIOS Updates

### Dell Support Website

1. **Go to**: https://www.dell.com/support
2. **Enter Service Tag**:
   - Find on sticker on the machine (usually bottom or back)
   - Format: Usually 7 alphanumeric characters
   - **Or** use Express Service Code
3. **Or search by model**: "OptiPlex 9020M"
4. **Navigate to**: Drivers & Downloads → BIOS
5. **Download latest BIOS** update file

### Direct Link (if you know Service Tag)

1. **Go to**: https://www.dell.com/support/home/en-us/product-support/servicetag/[YOUR_SERVICE_TAG]/drivers
2. **Filter by**: BIOS
3. **Download latest version**

### Manual Search

1. **Go to**: https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=XXXXX
2. **Search**: "OptiPlex 9020M BIOS"
3. **Download**: Latest BIOS update

## BIOS Update Methods

### Method 1: Update from Windows (Easiest - if Windows is installed)

1. **Download BIOS update** from Dell Support
2. **File format**: Usually `.exe` (e.g., `OptiPlex_9020M_BIOS_A28.exe`)
3. **Run the .exe file** as Administrator
4. **Follow on-screen instructions**
5. **System will reboot** and update BIOS automatically
6. **Do NOT power off** during update!

### Method 2: Update from BIOS (Recommended if no OS installed)

**For Dell OptiPlex 9020M BIOS file `9020MA19.exe`:**

**Note**: If the .exe file can't be extracted, try using it directly in BIOS menu, or use the DOS method (see below).

1. **Download BIOS update** from Dell Support
   - File: `9020MA19.exe` (9.42 MB)
   - From: https://www.dell.com/support/home/en-ca/drivers/driversdetails?driverid=xw37h

2. **Extract the .exe file**:
   - Dell BIOS .exe files are self-extracting archives
   - **On Windows**: Right-click `9020MA19.exe` → **Extract All** (or use 7-Zip/WinRAR)
   - **On Mac/Linux**: Use `unzip` or `7z` command (see extraction methods below)
   - The .exe file contains the actual BIOS file inside

3. **Find the BIOS file**:
   - After extraction, look for a file like `9020MA19.exe` (same name, but this is the actual BIOS file)
   - **OR** look for a `.bin` or `.rom` file
   - **OR** the extracted folder may contain the BIOS file directly
   - For OptiPlex 9020M, the file is typically named `9020MA19.exe` (the extracted version)

4. **Copy to USB drive**:
   - Format USB drive as **FAT32**
   - Copy the BIOS file (`.exe`, `.bin`, or `.rom`) to the **root** of the USB drive
   - Do NOT put it in a folder - it must be in the root directory

5. **Boot into BIOS** (F2)

6. **Navigate to**: `Maintenance` → `BIOS Update` or `Flash Update` or `Firmware Update`

7. **Select USB drive** and BIOS file

8. **Start update**

9. **Wait for completion** (do NOT interrupt!)

10. **System reboots** automatically

### Method 3: Update from Ubuntu (After installation)

1. **Download BIOS update** from Dell Support
2. **Extract the .exe file**:
   ```bash
   # Some Dell BIOS updates are self-extracting
   # You may need to use 7zip or similar
   sudo apt install p7zip-full
   unzip OptiPlex_9020M_BIOS_A28.exe
   ```

3. **Use fwupd** (if supported):
   ```bash
   # Install fwupd
   sudo apt install fwupd
   
   # Check for updates
   sudo fwupdmgr refresh
   sudo fwupdmgr get-updates
   sudo fwupdmgr update
   ```

4. **Or use Dell's Linux tools** (if available):
   - Check Dell's Linux repository
   - Some models have Linux-specific update tools

## Recommended: Update Before Ubuntu Installation

**Best practice**: Update BIOS **before** installing Ubuntu:

1. **If Windows is still installed**: Update from Windows (easiest)
2. **If no OS installed**: Update from BIOS using USB
3. **Then install Ubuntu** with latest BIOS

## BIOS Update Process (Step-by-Step)

### From Windows

1. **Download BIOS update** from Dell Support
2. **Close all applications**
3. **Plug in AC adapter** (don't use battery only)
4. **Run BIOS update .exe** as Administrator
5. **Read and accept** any warnings
6. **Click "Update"** or "Flash"
7. **System will reboot**
8. **BIOS update screen** will appear
9. **Wait for completion** (5-10 minutes)
10. **System will reboot again**
11. **Enter BIOS** (F2) to verify new version

### From BIOS (USB Method)

1. **Download BIOS update** from Dell
2. **Format USB drive** as FAT32
3. **Copy BIOS file** to USB root directory
4. **Boot into BIOS** (F2)
5. **Navigate to**: `Maintenance` → `BIOS Update`
6. **Select USB drive**
7. **Select BIOS file**
8. **Start update**
9. **Wait for completion** (do NOT power off!)
10. **System reboots** automatically
11. **Verify version** in BIOS

### Method 2B: Update from DOS (If BIOS Menu Doesn't Work)

**If the .exe can't be extracted or BIOS menu can't read it, use DOS method:**

1. **Create bootable DOS USB**:
   - Use **Rufus**
   - Select your USB drive
   - Boot selection: **FreeDOS** (Rufus can download it automatically)
   - Partition scheme: **MBR**
   - File system: **FAT32**
   - Click **START**

2. **Copy `9020MA19.exe`** to USB root (no extraction needed!)

3. **Boot from USB**:
   - Insert USB in Dell OptiPlex 9020M
   - Press **F12** during boot
   - Select **USB Storage Device**

4. **At DOS prompt**, type:
   ```
   9020MA19.exe
   ```
   Press Enter

5. **BIOS update starts** automatically
6. **Wait for completion** (do NOT interrupt!)
7. **System reboots** when done
8. **Verify version** in BIOS (F2)

**This method works 100% - no extraction needed!**

## Important Warnings

⚠️ **CRITICAL**: 

1. **Do NOT power off** during BIOS update
2. **Use AC power** (plugged in, not battery)
3. **Close all applications** before updating
4. **Backup important data** (though BIOS update shouldn't affect data)
5. **Don't interrupt** the update process
6. **Update can take 5-15 minutes**

## Verifying BIOS Update

After update completes:

1. **Enter BIOS** (F2)
2. **Check version** on main screen
3. **Should show new version** (e.g., A28 instead of A25)
4. **Verify settings** are still correct:
   - Boot Mode: UEFI
   - SATA Operation: AHCI
   - Secure Boot: Disabled

## Troubleshooting

### Update Fails

1. **Try different USB drive** (some drives have issues)
2. **Format USB as FAT32** (not NTFS or exFAT)
3. **Try from Windows** if available (more reliable)
4. **Check file integrity** - re-download BIOS file
5. **Contact Dell Support** if persistent issues

### System Won't Boot After Update

1. **Reset BIOS to defaults**:
   - Remove CMOS battery (if accessible)
   - Or use BIOS reset jumper
2. **Check all connections**
3. **Try minimal hardware** (remove non-essential components)
4. **Contact Dell Support** if still not working

### Can't Find BIOS Update

1. **Check Service Tag** is correct
2. **Try searching by model** instead of Service Tag
3. **Check Dell's legacy support** section
4. **Contact Dell Support** with Service Tag

## Finding Your Service Tag

**Location on Dell OptiPlex 9020M**:
- **Bottom of the machine** (sticker)
- **Back panel** (sticker)
- **BIOS screen** (displays on boot)
- **Windows**: `wmic bios get serialnumber`

**Format**: Usually 7 alphanumeric characters (e.g., "ABC1234")

## BIOS Update Checklist

Before updating:

- [ ] Service Tag identified
- [ ] Current BIOS version noted
- [ ] Latest BIOS version downloaded
- [ ] AC adapter plugged in
- [ ] All applications closed
- [ ] Important data backed up
- [ ] USB drive ready (if using BIOS method)
- [ ] Ready to wait 5-15 minutes without interruption

After updating:

- [ ] BIOS version verified
- [ ] BIOS settings checked/restored
- [ ] System boots normally
- [ ] Ready to install Ubuntu

## Recommended BIOS Versions

For Dell OptiPlex 9020M:
- **Latest available** (check Dell Support)
- **A28 or newer** (if available) - better Ubuntu compatibility
- **Any version with security updates** from 2020+

## Extracting BIOS .exe File for BIOS Menu Update

### Method 1: Extract on Windows (Easiest)

1. **Download** `9020MA19.exe` from Dell Support
2. **Right-click** the file → **Extract All...**
3. **Choose extraction location** (e.g., Desktop)
4. **Extract**
5. **Look in extracted folder** for:
   - `9020MA19.exe` (the actual BIOS file - same name!)
   - Or `.bin` / `.rom` file
6. **Copy this file** to root of FAT32 USB drive

### Method 2: Extract with 7-Zip (Windows)

1. **Install 7-Zip** (if not installed): https://www.7-zip.org/
2. **Right-click** `9020MA19.exe` → **7-Zip** → **Extract to "9020MA19\"**
3. **Open extracted folder**
4. **Find BIOS file** (usually same name as .exe or .bin/.rom)
5. **Copy to USB** root directory

### Method 3: Extract on Mac/Linux

```bash
# Install 7zip if needed
# Mac: brew install p7zip
# Linux: sudo apt install p7zip-full

# Extract the .exe file
7z x 9020MA19.exe

# Or try unzip (some Dell files work with this)
unzip 9020MA19.exe

# Look for BIOS file in extracted folder
ls -la

# Copy to USB (replace /dev/sdX with your USB device)
# WARNING: Double-check device name!
sudo mount /dev/sdX1 /mnt
sudo cp 9020MA19.exe /mnt/  # or whatever the BIOS file is named
sudo umount /mnt
```

### Method 4: Use Dell's Built-in Extraction

Some Dell BIOS .exe files can be "run" to extract:

1. **Double-click** `9020MA19.exe`
2. **If it asks to extract** (not install), choose extract location
3. **Find extracted files**
4. **Copy BIOS file** to USB

### What to Look For

After extraction, you should find:
- **`9020MA19.exe`** - This is likely the BIOS file (same name as archive)
- **`9020MA19.bin`** or **`9020MA19.rom`** - Alternative BIOS file format
- **`FLASHBIOS.EXE`** - Sometimes included (for DOS flashing)
- **Readme or instructions file** - May contain specific instructions

**Important**: The BIOS file for BIOS menu update is usually the `.exe` file with the same name, or a `.bin`/`.rom` file. The BIOS update menu can read these formats.

### Verification

Before using in BIOS:
1. **File is on USB root** (not in a folder)
2. **USB is FAT32** formatted
3. **File size** should be several MB (not the full 9.42MB archive)
4. **File extension** is `.exe`, `.bin`, or `.rom`

## Resources

- **Dell Support**: https://www.dell.com/support
- **Dell Drivers & Downloads**: https://www.dell.com/support/home/en-us/drivers
- **Dell BIOS Update Guide**: https://www.dell.com/support/kbdoc/en-us/000124196/how-to-update-the-bios-on-your-dell-computer
- **Your BIOS Update**: https://www.dell.com/support/home/en-ca/drivers/driversdetails?driverid=xw37h

## Quick Reference

**Update from Windows** (if available):
1. Download .exe from Dell
2. Run as Administrator
3. Follow prompts
4. Wait for reboot and completion

**Update from BIOS** (if no OS):
1. Download BIOS file
2. Copy to FAT32 USB
3. Boot to BIOS (F2)
4. Use BIOS Update option
5. Select file from USB
6. Wait for completion

**After Ubuntu install**:
1. Use `fwupdmgr` if supported
2. Or download and extract Dell BIOS update manually

## Next Steps

After BIOS is updated:

1. **Verify BIOS version** in BIOS setup
2. **Configure BIOS settings** (see `bios-settings-dell-9020m.md`)
3. **Install Ubuntu Server** (see `ubuntu-installation-guide.md`)
4. **Set up your homelab**!

