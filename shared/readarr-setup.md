# Readarr Setup Guide

[Readarr](https://readarr.com/) is the audiobook and ebook management service in the Servarr stack. It's similar to Sonarr (TV), Radarr (Movies), and Lidarr (Music), but specifically designed for books and audiobooks.

## Access

**URL**: http://192.168.1.11:8787

## Features

- **Audiobook Management**: Automatically download and organize audiobooks
- **Ebook Management**: Also supports ebooks (EPUB, MOBI, etc.)
- **Author Tracking**: Track authors and get notified of new releases
- **Quality Profiles**: Set preferred formats and quality for audiobooks
- **Automatic Import**: Automatically import completed downloads
- **Metadata**: Rich metadata from Goodreads, OpenLibrary, etc.

## Initial Setup

### Step 1: Start Readarr

```bash
cd ~/homelab/node2
docker compose up -d readarr
```

### Step 2: Access Web UI

1. Open http://192.168.1.11:8787 in your browser
2. The setup wizard will guide you through initial configuration

### Step 3: Configure Root Folders

1. Go to **Settings** → **Media Management** → **Root Folders**
2. Add root folders:
   - **Audiobooks**: `/audiobooks` (maps to `/mnt/nas/audiobooks` on host)
   - **Books** (optional): `/books` (maps to `/mnt/nas/books` on host for ebooks)

### Step 4: Connect to Prowlarr

1. Go to **Settings** → **Indexers**
2. Click **Add Indexer** → **Prowlarr**
3. Enter:
   - **Name**: Prowlarr
   - **Host**: `prowlarr`
   - **Port**: `9696`
   - **API Key**: Get from Prowlarr (Settings → General → API Key)
4. Test and save

### Step 5: Connect to qBittorrent

1. Go to **Settings** → **Download Clients**
2. Click **Add Download Client** → **qBittorrent**
3. Enter:
   - **Name**: qBittorrent
   - **Host**: `qbittorrent`
   - **Port**: `8080`
   - **Username**: `admin` (or your qBittorrent username)
   - **Password**: Your qBittorrent password
4. **Category**: `readarr` (optional, helps organize downloads)
5. Test and save

### Step 6: Configure Media Management

1. Go to **Settings** → **Media Management**
2. Configure:
   - **Rename Books**: Enable to organize files
   - **File Date**: Set to "Release Date" or "Book Release Date"
   - **Permissions**: Set to match your user (PUID/PGID: 1000)

### Step 7: Set Up Quality Profiles

1. Go to **Settings** → **Profiles**
2. Create or edit quality profiles:
   - **Audiobook Formats**: MP3, M4B, FLAC, etc.
   - **Preferred Quality**: Set your preferred format
   - **Minimum/Maximum Size**: Set limits if needed

### Step 8: Add Authors/Books

1. Go to **Authors** (or **Books**)
2. Click **Add New** or use the search
3. Search for authors or specific books
4. Add to library
5. Readarr will automatically search for and download available books

## NAS Folder Setup

Make sure you have the folders on your Synology NAS:

1. **Create folders on NAS**:
   - `audiobooks` - For audiobook files
   - `books` - For ebook files (optional)

2. **Mount on Node 2** (if not already done):
   ```bash
   # Add to /etc/fstab
   # NAS_IP:/volume1/audiobooks /mnt/nas/audiobooks nfs defaults 0 0
   # NAS_IP:/volume1/books /mnt/nas/books nfs defaults 0 0
   
   sudo mkdir -p /mnt/nas/{audiobooks,books}
   sudo mount -a
   ```

## Integration with Other Services

### Prowlarr
- Readarr uses Prowlarr to search for books/audiobooks
- Prowlarr manages all your indexers in one place

### qBittorrent
- Downloads are sent to qBittorrent
- Readarr monitors downloads and imports when complete

### Overseerr/Ombi
- Can be configured to allow requests for books/audiobooks
- Users can request specific books through the request interface

## Tips

1. **Author vs Book**: Readarr can track by author (downloads all books by an author) or by individual book
2. **Audiobook Formats**: M4B is popular for audiobooks (single file with chapters)
3. **Metadata**: Readarr pulls metadata from Goodreads, OpenLibrary, and other sources
4. **Monitoring**: Set up monitoring to get notified of new releases from tracked authors
5. **Calibre Integration**: If you use Calibre for ebooks, you can integrate it with Readarr

## Common Use Cases

### Audiobook Library
- Track favorite authors
- Automatically download new releases
- Organize by author/series
- Serve to Plex or other media servers

### Ebook Library
- Manage ebook collection
- Track reading progress (if using compatible apps)
- Organize by author/genre

## Troubleshooting

### Downloads Not Importing
- Check download client connection
- Verify root folder paths are correct
- Check file permissions
- Review logs: `docker compose logs readarr`

### Can't Find Books
- Check indexer configuration in Prowlarr
- Verify indexers support books/audiobooks
- Check quality profile settings

### Permission Issues
- Ensure PUID/PGID match your user (1000:1000)
- Check NAS mount permissions
- Verify Docker volume permissions

## Resources

- **Official Docs**: https://wiki.servarr.com/readarr
- **GitHub**: https://github.com/Readarr/Readarr
- **Discord**: https://readarr.com/discord

