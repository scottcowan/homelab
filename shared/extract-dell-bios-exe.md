# How to Extract Dell BIOS .exe for BIOS Menu Update

This guide shows how to extract `9020MA19.exe` so you can use it in the BIOS update menu.

## Quick Answer

Dell BIOS `.exe` files are self-extracting archives. Extract it to get the actual BIOS file, then copy that file to a FAT32 USB drive.

## Step-by-Step: Extract 9020MA19.exe

### On Windows (Easiest)

1. **Download** `9020MA19.exe` from Dell Support
   - File: 9.42 MB
   - From: https://www.dell.com/support/home/en-ca/drivers/driversdetails?driverid=xw37h

2. **Extract the file**:
   - **Option A**: Right-click `9020MA19.exe` → **Extract All...**
   - **Option B**: Use 7-Zip (right-click → 7-Zip → Extract)
   - **Option C**: Double-click and choose "Extract" if prompted

3. **Find the BIOS file**:
   - Open the extracted folder
   - Look for: `9020MA19.exe` (the actual BIOS file - same name!)
   - Or: `9020MA19.bin` / `9020MA19.rom`
   - **Note**: The extracted BIOS file will be smaller than 9.42 MB

4. **Copy to USB**:
   - Format USB drive as **FAT32**
   - Copy the BIOS file to the **root** of the USB (not in a folder)
   - File should be directly on USB, e.g., `E:\9020MA19.exe`

### On Mac

```bash
# Install 7zip if needed
brew install p7zip

# Extract the .exe file
7z x 9020MA19.exe

# Or try unzip
unzip 9020MA19.exe

# Find the BIOS file
ls -la

# Copy to USB (mount USB first, then copy)
cp 9020MA19.exe /Volumes/USB/
```

### On Linux

```bash
# Install 7zip if needed
sudo apt install p7zip-full

# Extract the .exe file
7z x 9020MA19.exe

# Or try unzip
unzip 9020MA19.exe

# Find the BIOS file
ls -la

# Copy to USB (replace /dev/sdX1 with your USB device)
sudo mount /dev/sdX1 /mnt
sudo cp 9020MA19.exe /mnt/  # or .bin/.rom file
sudo umount /mnt
```

## What File to Use

After extraction, you'll typically find:

- **`9020MA19.exe`** ✅ **Use this** - This is the BIOS file (same name as archive)
- **`9020MA19.bin`** ✅ Alternative - Some BIOS menus prefer .bin
- **`9020MA19.rom`** ✅ Alternative - Some BIOS menus prefer .rom
- **`FLASHBIOS.EXE`** - For DOS flashing (not needed for BIOS menu)

**For OptiPlex 9020M BIOS menu**: Use the `9020MA19.exe` file (the extracted one, not the archive).

## USB Preparation

1. **Format USB as FAT32**:
   - Windows: Right-click USB → Format → File system: FAT32
   - Mac: Disk Utility → Erase → MS-DOS (FAT)
   - Linux: `sudo mkfs.vfat /dev/sdX1`

2. **Copy BIOS file to USB root**:
   - **Must be in root** (not in a folder)
   - Example: `E:\9020MA19.exe` ✅
   - NOT: `E:\BIOS\9020MA19.exe` ❌

3. **Safely eject USB**

## Using in BIOS Menu

1. **Insert USB** into Dell OptiPlex 9020M
2. **Boot and press F2** to enter BIOS
3. **Navigate to**: 
   - `Maintenance` → `BIOS Update`
   - Or `Advanced` → `BIOS Update`
   - Or `System Utilities` → `BIOS Update`
4. **Select USB drive**
5. **Select BIOS file** (`9020MA19.exe`)
6. **Start update**
7. **Wait for completion** (5-10 minutes, do NOT interrupt!)

## Troubleshooting

### Can't Extract .exe File

**If the .exe won't extract, it's likely an installer, not an archive. Try these methods:**

#### Method 1: Run the .exe to Extract (Windows)

Some Dell BIOS .exe files will extract when you run them:

1. **Double-click** `9020MA19.exe`
2. **If it shows an extraction dialog** (not installation), choose a folder to extract to
3. **Look in that folder** for the BIOS file
4. **Cancel/close** the installer if it tries to install

#### Method 2: Use the .exe Directly in BIOS

**Good news**: Many Dell BIOS update menus can read the .exe file directly!

1. **Copy `9020MA19.exe`** directly to FAT32 USB (don't extract)
2. **Boot to BIOS** (F2)
3. **Navigate to BIOS Update**
4. **Select the .exe file** - BIOS menu may be able to read it
5. **If it works**, the BIOS will extract and update automatically

#### Method 3: Use Universal Extractor or InstallShield Unpacker

1. **Download Universal Extractor**: http://www.legroom.net/software/uniextract
2. **Right-click** `9020MA19.exe` → **UniExtract to Subfolder**
3. **Check extracted folder** for BIOS file

#### Method 4: Use 7-Zip Command Line (More Forceful)

```bash
# On Windows (Command Prompt)
7z x 9020MA19.exe -oextracted

# On Mac/Linux
7z x 9020MA19.exe -oextracted
```

#### Method 5: Use DOS Method Instead

If extraction doesn't work, use the DOS method (works with .exe directly):

1. **Create bootable DOS USB** (use Rufus with FreeDOS)
2. **Copy `9020MA19.exe`** to USB
3. **Boot from USB** (F12)
4. **At DOS prompt**: Type `9020MA19.exe` and press Enter
5. **BIOS will update** automatically

### BIOS Menu Can't Find File

- **Check USB is FAT32** (not NTFS or exFAT)
- **Check file is in root** (not in a folder)
- **Try renaming** to shorter name (e.g., `BIOS.exe`)
- **Try different USB drive**

### File Too Large

- The extracted BIOS file should be smaller than 9.42 MB
- If it's still 9.42 MB, you may have copied the archive instead of extracted file
- Re-extract and look for the actual BIOS file inside

## Verification Checklist

Before using in BIOS:

- [ ] File extracted successfully
- [ ] Found BIOS file (`.exe`, `.bin`, or `.rom`)
- [ ] USB formatted as FAT32
- [ ] BIOS file copied to USB root directory
- [ ] File size is reasonable (not the full 9.42 MB archive)
- [ ] USB safely ejected

## Alternative: Use DOS Method

If BIOS menu doesn't work, you can also:

1. **Create bootable DOS USB**
2. **Copy `9020MA19.exe`** to USB
3. **Boot from USB** (F12)
4. **Run**: `9020MA19.exe` from DOS prompt
5. **BIOS will update** automatically

See the Dell documentation for DOS method details.

## Alternative: Use .exe Directly (No Extraction Needed)

**Important**: Many Dell BIOS update menus can use the .exe file directly without extraction!

### Try This First:

1. **Copy `9020MA19.exe`** directly to FAT32 USB root (no extraction)
2. **Boot to BIOS** (F2)
3. **Navigate to**: `Maintenance` → `BIOS Update`
4. **Select USB drive**
5. **Select `9020MA19.exe`** file
6. **Try to start update** - BIOS menu may handle the .exe directly

If this works, you don't need to extract anything!

### If BIOS Menu Can't Read .exe:

Then use the **DOS method** (see below) - it definitely works with the .exe file.

## DOS Method (Works Without Extraction)

If extraction doesn't work or BIOS menu can't read .exe:

1. **Create bootable DOS USB**:
   - Use Rufus
   - Select your USB
   - Boot selection: **FreeDOS** (Rufus can download it)
   - Partition: MBR
   - Click START

2. **Copy `9020MA19.exe`** to USB root

3. **Boot from USB**:
   - Insert USB in Dell OptiPlex 9020M
   - Press F12 during boot
   - Select USB drive

4. **At DOS prompt**:
   ```
   C:\> 9020MA19.exe
   ```

5. **BIOS will update** automatically
6. **System reboots** when done

This method works 100% - no extraction needed!

## Quick Reference

**Option 1 - Try Direct .exe in BIOS**:
1. Copy `9020MA19.exe` to FAT32 USB
2. Boot to BIOS (F2)
3. Maintenance → BIOS Update
4. Select .exe file
5. Try to update (may work directly!)

**Option 2 - DOS Method** (if BIOS menu doesn't work):
1. Create FreeDOS USB with Rufus
2. Copy `9020MA19.exe` to USB
3. Boot from USB (F12)
4. Run: `9020MA19.exe`
5. BIOS updates automatically

**No extraction needed** - the .exe file can be used directly in DOS or sometimes in BIOS menu!

