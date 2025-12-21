# Rufus Settings for Dell Optiplex 9020M

## Recommended Settings

For Dell Optiplex 9020M with UEFI boot mode:

| Setting | Value | Why |
|---------|-------|-----|
| **Partition scheme** | **GPT** | Required for UEFI boot |
| **Target system** | **UEFI (non CSM)** | Matches UEFI boot mode in BIOS |
| **File system** | **FAT32** | Default, works with UEFI |
| **Cluster size** | **4096 bytes** | Default, optimal |

## Why GPT?

1. **UEFI Requirement**: GPT is required when using UEFI boot mode
2. **Hardware Support**: Dell Optiplex 9020M supports UEFI (2014-2015 era)
3. **Modern Standard**: GPT is the modern standard, MBR is legacy
4. **Better Compatibility**: Works better with modern Ubuntu Server
5. **BIOS Settings Match**: We configured BIOS for UEFI, so USB must be GPT

## GPT vs MBR

### GPT (GUID Partition Table) ✅ Use This

- **Required for**: UEFI boot mode
- **Supports**: Drives larger than 2TB
- **Modern standard**: Used by all modern systems
- **Your hardware**: Dell Optiplex 9020M supports this

### MBR (Master Boot Record) ❌ Don't Use

- **Only for**: Legacy/BIOS boot mode
- **Limitation**: Max 2TB drives (not an issue for 500GB)
- **Legacy**: Older standard, being phased out
- **Your hardware**: Would require changing BIOS to Legacy mode

## Complete Rufus Configuration

For Dell Optiplex 9020M:

```
Device: [Your USB Drive]
Boot selection: [SELECT] → Choose Ubuntu Server ISO
Partition scheme: GPT ✅
Target system: UEFI (non CSM) ✅
Volume label: [Auto-filled, can leave]
File system: FAT32 ✅
Cluster size: 4096 bytes ✅
```

## What If GPT Doesn't Work?

If for some reason GPT/UEFI doesn't work (unlikely):

1. **Try MBR + Legacy**:
   - Partition scheme: **MBR**
   - Target system: **BIOS or UEFI-CSM**
   - **Also change BIOS**: Boot Mode → **Legacy** (not recommended)

2. **But first troubleshoot**:
   - Check BIOS is set to UEFI
   - Try different USB port
   - Try different USB drive
   - Verify Ubuntu ISO downloaded correctly

## Verification

After creating USB with GPT:

1. **Check USB in Windows**:
   - Open File Explorer
   - USB should show as "EFI" or "UEFI" partition
   - Should be FAT32 formatted

2. **Test boot**:
   - Insert USB in Dell Optiplex 9020M
   - Boot and press F12
   - USB should appear as "UEFI: [USB Name]"
   - Select it and Ubuntu installer should start

## Quick Answer

**Yes, choose GPT** because:
- ✅ Your BIOS is set to UEFI mode
- ✅ GPT is required for UEFI
- ✅ Your hardware supports it
- ✅ Modern standard, better compatibility

**Don't choose MBR** unless:
- ❌ You're using Legacy boot mode (not recommended)
- ❌ GPT doesn't work after troubleshooting (very unlikely)

## Summary

**For Dell Optiplex 9020M:**
- **Partition scheme**: **GPT** ✅
- **Target system**: **UEFI (non CSM)** ✅
- **File system**: **FAT32** ✅

This matches your BIOS configuration (UEFI boot mode) and will work perfectly with Ubuntu Server installation.

