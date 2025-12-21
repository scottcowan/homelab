# Profile Configuration Examples for Ubuntu Installation

## Profile Setup Screen

During Ubuntu Server installation, you'll be asked for:
- Your name (full name)
- Server name (hostname)
- Username
- Password

## Recommended Configuration

### Node 1 (Pterodactyl Panel + Core Services)

**Your name**: 
- `Homelab Admin` or `Scott Cowan` (your actual name)

**Server name**:
- `node1` ✅ (Simple and clear)
- Or: `homelab-node1`
- Or: `pterodactyl-panel`

**Username**:
- `admin` ✅ (Recommended - same on all nodes)
- Or: `homelab`
- Or: `scott` (your name)

**Password**:
- Strong password (store in password manager)
- Same password on all nodes? Your choice

### Node 2 (Wings + Servarr Stack)

**Your name**: 
- Same as Node 1 (for consistency)

**Server name**:
- `node2` ✅
- Or: `homelab-node2`
- Or: `wings-servarr`

**Username**:
- `admin` ✅ (Same as Node 1 - recommended)

**Password**:
- Same as Node 1? (Easier management)
- Or different? (More secure)

### Node 3 (Additional Services)

**Your name**: 
- Same as Node 1

**Server name**:
- `node3` ✅
- Or: `homelab-node3`
- Or: `services`

**Username**:
- `admin` ✅ (Same as Node 1 - recommended)

**Password**:
- Same as Node 1? (Easier)
- Or different? (More secure)

## Best Practices

### Username Consistency

**Recommended**: Use the **same username** on all 3 nodes:
- Easier SSH access (same username everywhere)
- Consistent permissions
- Simpler management

**Examples**:
- `admin` - Simple, clear
- `homelab` - Descriptive
- `scott` - Personal name

### Server Names (Hostnames)

**Recommended**: Use simple, sequential names:
- `node1`, `node2`, `node3` ✅
- Easy to remember
- Clear identification
- Can be changed later if needed

**Alternative naming schemes**:
- `homelab-node1`, `homelab-node2`, `homelab-node3`
- `pterodactyl-panel`, `wings-servarr`, `services`
- `lab-01`, `lab-02`, `lab-03`

### Password Strategy

**Option 1: Same password on all nodes** (Easier)
- ✅ Easier to remember
- ✅ Faster setup
- ❌ If compromised, all nodes at risk

**Option 2: Different passwords** (More secure)
- ✅ Better security
- ✅ If one compromised, others safe
- ❌ Harder to remember
- ✅ Use password manager

**Recommendation**: Use a password manager and use different strong passwords for each node.

### Password Requirements

- **Minimum**: 8 characters
- **Recommended**: 12+ characters
- **Include**: Letters (upper/lower), numbers, symbols
- **Example**: `MyH0m3l@b2024!`

**Generate strong passwords**:
- Use password manager (1Password, Bitwarden, etc.)
- Or: `openssl rand -base64 16` (after installation)

## Changing After Installation

All of these can be changed later:

### Change Hostname

```bash
# Change server name
sudo hostnamectl set-hostname newname

# Update /etc/hosts
sudo nano /etc/hosts
# Change: 127.0.1.1 oldname → 127.0.1.1 newname
```

### Change Username

```bash
# Create new user
sudo adduser newusername
sudo usermod -aG sudo newusername

# Logout and login as new user
# Then delete old user (if desired)
sudo deluser oldusername
```

### Change Password

```bash
# Change your own password
passwd

# Or change another user's password (as root)
sudo passwd username
```

## Quick Reference

**Recommended for all nodes**:

| Field | Node 1 | Node 2 | Node 3 |
|-------|--------|--------|--------|
| **Your name** | Homelab Admin | Homelab Admin | Homelab Admin |
| **Server name** | `node1` | `node2` | `node3` |
| **Username** | `admin` | `admin` | `admin` |
| **Password** | Strong, unique | Strong, unique | Strong, unique |

**Or use descriptive names**:

| Field | Node 1 | Node 2 | Node 3 |
|-------|--------|--------|--------|
| **Server name** | `pterodactyl-panel` | `wings-servarr` | `services` |
| **Username** | `admin` | `admin` | `admin` |

## Security Notes

1. **SSH Keys**: After installation, set up SSH key authentication
2. **Disable password auth**: Once SSH keys work, disable password login
3. **Password manager**: Store all passwords securely
4. **Different passwords**: Use different passwords for each node if possible

## Example Configuration

**Node 1**:
- Your name: `Homelab Admin`
- Server name: `node1`
- Username: `admin`
- Password: `[Strong password from password manager]`

**Node 2**:
- Your name: `Homelab Admin`
- Server name: `node2`
- Username: `admin`
- Password: `[Different strong password]`

**Node 3**:
- Your name: `Homelab Admin`
- Server name: `node3`
- Username: `admin`
- Password: `[Different strong password]`

This gives you consistent usernames but unique passwords for better security.

