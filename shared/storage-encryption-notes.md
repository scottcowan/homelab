# Storage Encryption Decision - LUKS for Homelab

## Recommendation: **Do NOT Use LUKS Encryption**

For your homelab setup, **skip LUKS encryption** during Ubuntu Server installation.

## Why Skip Encryption for Homelab?

### Performance Impact

- **Slower disk I/O**: Encryption adds CPU overhead
- **Reduced throughput**: Especially noticeable with:
  - Docker containers
  - Database operations (MariaDB, PostgreSQL)
  - Media file operations (Servarr stack)
  - Game server I/O (Pterodactyl)

### Operational Complexity

- **Remote reboots**: Requires manual key entry (unless configured for automatic unlock)
- **Recovery**: More complex if system fails
- **Backup/restore**: Additional steps required
- **Disk management**: More complex volume operations

### Security Considerations

- **Physical security**: Homelab servers are usually in secure locations
- **Network security**: More important to secure network access
- **Application security**: Focus on securing services, not disk encryption
- **Backup security**: Encrypt backups instead if needed

## When You WOULD Use Encryption

Encryption makes sense for:

- **Laptops/portable devices**: Risk of theft
- **Compliance requirements**: HIPAA, GDPR, etc.
- **Multi-tenant environments**: Shared hosting
- **Highly sensitive data**: Financial, medical records
- **Regulatory requirements**: Specific industry standards

## For Your Homelab

Your setup:
- ✅ Servers in fixed location (London)
- ✅ Physical security (locked room/rack)
- ✅ Network security (firewall, SSH keys)
- ✅ Application-level security (service authentication)

**Conclusion**: Physical and network security are more important than disk encryption for homelab servers.

## Alternative Security Measures

Instead of disk encryption, focus on:

1. **Network Security**:
   - Firewall (UFW)
   - SSH key authentication
   - VPN for remote access
   - Fail2Ban for brute force protection

2. **Application Security**:
   - Strong passwords
   - Service authentication
   - Regular updates
   - Secure configurations

3. **Backup Security**:
   - Encrypt backups if storing off-site
   - Use encrypted backup tools (Duplicati, etc.)

4. **Physical Security**:
   - Locked server room/rack
   - Access control
   - Security cameras (if needed)

## Installation Choice

During Ubuntu Server installation:

**Storage Configuration**:
- ✅ **Use LVM**: Yes (for flexibility)
- ❌ **Encrypt LVM**: No (skip encryption)

**Result**: Faster performance, simpler management, easier recovery.

## If You Change Your Mind Later

You can add encryption later (though it requires reinstallation):

1. **Backup all data**
2. **Reinstall Ubuntu** with encryption enabled
3. **Restore data**

But for homelab use, this is usually unnecessary.

## Quick Answer

**Do NOT encrypt the LVM group** - choose "No" or leave unchecked.

Your homelab servers will:
- Run faster
- Be easier to manage
- Recover more easily
- Still be secure (network + physical security)

Focus security efforts on network and application layers instead of disk encryption.

