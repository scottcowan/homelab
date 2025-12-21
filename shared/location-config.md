# Location Configuration

## Timezone

All services are configured to use **Europe/London** timezone (GMT/BST).

This affects:
- Log timestamps
- Scheduled tasks
- Time-based features in applications
- Cron jobs

### Changing Timezone

If you need to change the timezone, update the `TZ` environment variable in your docker-compose files:

```yaml
environment:
  - TZ=Europe/London  # Change to your desired timezone
```

Common timezones:
- `Europe/London` - UK (GMT/BST)
- `America/New_York` - Eastern US (EST/EDT)
- `America/Los_Angeles` - Pacific US (PST/PDT)
- `America/Vancouver` - Pacific Canada (PST/PDT)
- `UTC` - Coordinated Universal Time

### System Timezone

Also ensure your Ubuntu Server system timezone is set correctly:

```bash
# Check current timezone
timedatectl

# Set timezone
sudo timedatectl set-timezone Europe/London

# Verify
date
```

## Network Considerations

### If Homelab is in London, UK

- **Latency**: If accessing from Vancouver, Canada, expect ~150-200ms latency
- **Remote Access**: Consider setting up a VPN for secure remote access
- **Port Forwarding**: If exposing services to internet, ensure proper security
- **DNS**: Consider using a dynamic DNS service if your IP changes

### Remote Management

Since you're in Vancouver but the homelab is in London:

1. **SSH Access**: Set up SSH key-based authentication
2. **VPN**: Consider setting up WireGuard or OpenVPN for secure access
3. **Portainer**: Can be accessed remotely (use HTTPS and strong passwords)
4. **Homepage**: Great for remote access to all services
5. **Uptime Kuma**: Monitor services from anywhere

### Security Recommendations

1. **Firewall**: Configure UFW on each node
   ```bash
   sudo ufw enable
   sudo ufw allow ssh
   sudo ufw allow from YOUR_VANCOUVER_IP  # Allow your IP
   ```

2. **Fail2Ban**: Install to prevent brute force attacks
   ```bash
   sudo apt install fail2ban -y
   ```

3. **SSH Hardening**: 
   - Disable password authentication
   - Use SSH keys only
   - Change default SSH port (optional)

4. **Reverse Proxy**: Consider using Traefik or Nginx Proxy Manager for:
   - SSL/TLS certificates (Let's Encrypt)
   - Single entry point
   - Better security

## Time Synchronization

Ensure NTP is working correctly:

```bash
# Check NTP status
timedatectl status

# Enable NTP if not enabled
sudo timedatectl set-ntp true

# Check sync
chrony sources  # or ntpq -p if using ntp
```

## Date/Time in Logs

All Docker containers will use the configured timezone for:
- Application logs
- Scheduled tasks
- Database timestamps
- File modification times (if using local volumes)

## Daylight Saving Time

Europe/London automatically handles:
- GMT (Greenwich Mean Time) in winter
- BST (British Summer Time) in summer
- DST transitions are automatic

No manual changes needed!

