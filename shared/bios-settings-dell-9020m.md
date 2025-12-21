# BIOS Settings Guide - Dell Optiplex 9020M

This guide covers the recommended BIOS settings for installing Ubuntu Server on your Dell Optiplex 9020M Micro Desktop.

**Note**: It's recommended to update your BIOS to the latest version before configuring these settings. See `bios-update-dell-9020m.md` for BIOS update instructions.

## Accessing BIOS

1. **Power on** the computer
2. **Press F2** repeatedly immediately after power button
3. **Alternative**: Press **F12** for one-time boot menu (doesn't require BIOS changes)

## Critical Settings (Must Configure)

### 1. Boot Mode: UEFI

**Path**: `Boot` → `Boot Mode`

- **Set to**: **UEFI** (not Legacy/CSM)
- **Why**: Modern Ubuntu Server works best with UEFI
- **Note**: If you set this, you must use GPT partition scheme in Rufus

### 2. SATA Operation: AHCI

**Path**: `System Configuration` → `SATA Operation`

- **Set to**: **AHCI**
- **Why**: Required for Ubuntu to properly detect your hard drive
- **Important**: If you change this on a system with Windows, Windows may not boot (but you're installing Ubuntu fresh, so this is fine)

### 3. Secure Boot: Disabled

**Path**: `Security` → `Secure Boot`

- **Set to**: **Disabled**
- **Why**: Makes Ubuntu installation easier (Ubuntu can work with Secure Boot, but disabling is simpler)
- **Note**: You can enable it later if needed

### 4. USB Boot: Enabled

**Path**: `System Configuration` → `USB Configuration`

- **USB Controller**: **Enabled**
- **USB Boot Support**: **Enabled** (should be default)
- **Why**: Required to boot from USB drive

## Recommended Settings

### Boot Sequence

**Path**: `Boot` → `Boot Sequence`

- **Option 1**: Move USB to top of boot order
- **Option 2**: Use F12 boot menu (easier, one-time selection)
- **Recommendation**: Use F12 menu - no permanent changes needed

### Virtualization

**Path**: `System Configuration` → `Virtualization`

- **Virtualization Technology (VT-x)**: **Enabled**
- **VT-d**: **Enabled** (if available)
- **Why**: Useful if you want to run VMs or containers later

### Power Management

**Path**: `Power Management`

- **Wake on LAN**: **Enabled** (if you want remote wake)
- **AC Recovery**: **Power On** (optional - auto-start after power loss)
- **Why**: Useful for homelab servers

### Security

**Path**: `Security`

- **Set Supervisor Password**: **Recommended**
  - Prevents unauthorized BIOS changes
  - Write it down securely!
- **TPM**: **Enabled** (if available, for future security features)

## Settings Summary

### Minimum Required Changes

For Ubuntu installation to work:

1. ✅ **Boot Mode**: UEFI
2. ✅ **SATA Operation**: AHCI
3. ✅ **Secure Boot**: Disabled
4. ✅ **USB Boot**: Enabled

### Recommended Additional Settings

For optimal homelab setup:

5. ✅ **Virtualization**: Enabled
6. ✅ **Wake on LAN**: Enabled
7. ✅ **Supervisor Password**: Set
8. ✅ **AC Recovery**: Power On

## Step-by-Step Configuration

### Before First Boot

1. **Power on** Dell Optiplex 9020M
2. **Press F2** immediately (before Dell logo)
3. **Navigate** using arrow keys and Enter
4. **Make changes** as listed above
5. **Save**: Press **F10** or go to `Exit` → `Save Changes and Exit`
6. **Confirm**: Select **Yes**
7. **System reboots**

### Booting from USB

1. **Insert USB** drive (with Ubuntu ISO)
2. **Power on** machine
3. **Press F12** during boot (Dell boot menu appears)
4. **Select** your USB drive from the list
5. **Ubuntu installer** should start

## Troubleshooting

### USB Not Appearing in Boot Menu

1. **Check USB is working**: Try on another computer
2. **Try different USB port**: Use USB 2.0 port (black, not blue)
3. **Recreate USB**: Use Rufus with different settings
4. **Check BIOS**: Ensure USB Boot Support is enabled

### Ubuntu Installer Can't See Hard Drive

1. **Check SATA Operation**: Must be set to **AHCI**
2. **Check drive is enabled**: `System Configuration` → `Drives`
3. **Try Legacy mode**: Change Boot Mode to Legacy (last resort)

### Installation Fails or Freezes

1. **Disable Secure Boot**: If still enabled
2. **Check USB drive**: Try different USB drive
3. **Try different USB port**: Front panel sometimes works better
4. **Check RAM**: Run memory test from Ubuntu installer

### Can't Access BIOS

1. **Try F12** instead of F2 (boot menu)
2. **Remove battery** (if accessible) to reset BIOS
3. **Check keyboard**: Try different keyboard or USB port
4. **Rapid press**: Press F2 very rapidly, multiple times

## BIOS Reset

If you need to reset BIOS to defaults:

1. **Enter BIOS** (F2)
2. **Go to**: `Exit` → `Load Defaults` or `Restore Settings`
3. **Confirm**: Yes
4. **Save and Exit**: F10

## After Ubuntu Installation

Once Ubuntu is installed, you can:

1. **Change boot order**: Set hard drive as first (USB can be second)
2. **Enable Secure Boot**: If you want (Ubuntu supports it)
3. **Keep other settings**: Virtualization, Wake on LAN, etc.

## Quick Reference

| Setting | Location | Value |
|---------|----------|-------|
| Boot Mode | Boot → Boot Mode | UEFI |
| SATA Operation | System Config → SATA Operation | AHCI |
| Secure Boot | Security → Secure Boot | Disabled |
| USB Boot | System Config → USB Config | Enabled |
| Virtualization | System Config → Virtualization | Enabled |
| Wake on LAN | Power Management | Enabled |

## Notes

- **F2**: Enter BIOS setup
- **F12**: One-time boot menu (easier than changing boot order)
- **F10**: Save and exit BIOS
- **ESC**: Exit without saving

All settings can be changed later if needed. The critical ones for installation are Boot Mode (UEFI) and SATA Operation (AHCI).

