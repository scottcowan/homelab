# Node 1 First Setup - Step by Step

This guide will walk you through setting up Node 1 on your first mini PC.

## Prerequisites

- Ubuntu Server 22.04 LTS or 24.04 LTS installed
- Static IP configured (recommended: 192.168.1.10)
- SSH access enabled
- User account with sudo privileges

**Note**: This guide is for **Node 1 only**. See `shared/node-setup-summary.md` for what's needed on each node.

## Step 1: Initial System Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y


# Verify timezone
timedatectl
date
```

## Step 2: Install Docker and Docker Compose

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
# $USER automatically uses your current username - just copy and paste this command
sudo usermod -aG docker $USER

# Apply group changes (or log out and back in)
newgrp docker


# Verify installation
docker --version
docker compose version
```

## Step 3: Clone or Copy Your Homelab Files

If you have the homelab repository on another machine:

```bash
# Option A: If using git
git clone <your-repo-url> ~/homelab
cd ~/homelab

# Option B: If copying files manually
# Create directory structure
mkdir -p ~/homelab/node1
mkdir -p ~/homelab/shared

# Copy your docker-compose.yml and other files to ~/homelab/node1/
```

## Step 4: Set Up Environment Variables

```bash
cd ~/homelab/node1

# Copy the Node 1 environment template
cp ../shared/env-template-node1.txt .env
```

Generate secure passwords and update the `.env` file automatically:

**Option 1: Use the setup script (Easiest)**:

```bash
# Make script executable (one time)
chmod +x ../shared/scripts/setup-env-node1.sh

# Run the script
../shared/scripts/setup-env-node1.sh
```

This will automatically generate all passwords for Node 1 and update the .env file.

**Option 2: Run commands directly**:

```bash
# Generate and replace passwords in .env file automatically
sed -i "s|DB_PASSWORD=your_db_password_here|DB_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|DB_ROOT_PASSWORD=your_db_root_password_here|DB_ROOT_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|REDIS_PASSWORD=your_redis_password_here|REDIS_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|AUTHENTIK_SECRET_KEY=generate_random_key_here|AUTHENTIK_SECRET_KEY=$(openssl rand -base64 32)|g" .env
sed -i "s|APP_KEY=base64:generate_app_key_here|APP_KEY=base64:$(openssl rand -base64 32)|g" .env
sed -i "s|APP_URL=.*|APP_URL=http://192.168.1.10|g" .env

# Verify
grep -E "PASSWORD|SECRET_KEY|APP_URL|APP_KEY" .env
```

## Step 5: Start Core Services (Database & Redis First)

```bash
cd ~/homelab/node1

# Start only MariaDB and Redis first
docker compose up -d mariadb redis

# Wait for MariaDB to be ready (check logs)
docker compose logs -f mariadb

# Once you see "ready for connections", press Ctrl+C and continue
```

## Step 6: Start Portainer (Recommended Next)

Portainer will help you manage everything else:

```bash
# Start Portainer
docker compose up -d portainer

# Wait a few seconds, then access at:
# http://YOUR_IP:8000
```

**First-time Portainer setup:**
1. Open http://YOUR_IP:8000 in your browser
2. Create an admin account (username and password)
3. Select "Docker" environment
4. Click "Connect" to add your local Docker

## Step 7: Start Pterodactyl Panel (If Using Docker)

**Note:** Pterodactyl Panel can be tricky in Docker. You may want to install it directly on the host instead (see alternative below).

### Option A: Docker Installation

**Important:** Make sure `APP_KEY` is set in your `.env` file before starting the panel. The setup script automatically generates this, but if you're setting up manually, ensure it's configured.

```bash
# Start the panel
docker compose up -d panel

# Wait for it to start, then initialize
docker compose exec panel php artisan p:user:make
```

**Troubleshooting:** If you see an error about "no application encryption key has been specified", make sure:
1. `APP_KEY` is set in your `.env` file (should be in format `base64:...`)
2. You've restarted the panel container after adding `APP_KEY`: `docker compose restart panel`

### Option B: Host Installation (Recommended)

If Docker installation doesn't work well, install directly on the host:

```bash
# Keep MariaDB and Redis running in Docker
docker compose up -d mariadb redis

# Follow official Pterodactyl installation guide:
# https://pterodactyl.io/panel/1.11/getting_started.html
```

## Step 8: Start Remaining Services

```bash
# Start Uptime Kuma (monitoring)
docker compose up -d uptime-kuma

# Start Authentik (optional - authentication)
# Note: Authentik requires PostgreSQL and Redis, which will start automatically

# First, create required directories for Authentik
mkdir -p authentik/media/public authentik/media/private authentik/certs authentik/custom-templates
chmod -R 777 authentik/media authentik/certs authentik/custom-templates

# Then start Authentik services
docker compose up -d authentik-postgres authentik-redis authentik

# Start Homepage (landing page dashboard)
docker compose up -d homepage

# Start UniFi Controller (network management)
docker compose up -d unifi
```

**Note:** For initial setup, it's recommended to start services individually so you can monitor logs and troubleshoot. Once everything is working, you can use `docker compose up -d` to start all services at once.

## Step 9: Verify Everything is Running

```bash
# Check all containers
docker compose ps

# Or use Portainer UI to see all containers

# Check logs if anything isn't working
docker compose logs [service_name]
```

## Step 10: Access Your Services

Once everything is running, you can access:

- **Portainer**: http://YOUR_IP:8000
- **Pterodactyl Panel**: http://YOUR_IP (port 80)
- **Uptime Kuma**: http://YOUR_IP:3001
- **Authentik**: http://YOUR_IP:9000 (if enabled)
- **Homepage**: http://YOUR_IP:3000
- **UniFi Controller**: https://YOUR_IP:8443 (accept self-signed certificate)

## Troubleshooting

### Portainer won't start
```bash
# Check logs
docker compose logs portainer

# Ensure Docker socket is accessible
ls -la /var/run/docker.sock
```

### MariaDB connection issues
```bash
# Check if MariaDB is ready
docker compose exec mariadb mysqladmin ping -h localhost

# Check MariaDB logs
docker compose logs mariadb
```

### Can't access services from browser
- Check firewall: `sudo ufw status`
- Allow ports: `sudo ufw allow 8000,80,3001,9000/tcp`
- Check if services are listening: `sudo netstat -tlnp | grep -E '8000|80|3001|9000'`

### Permission denied errors
```bash
# Ensure user is in docker group
groups

# If not, add and re-login
sudo usermod -aG docker $USER
newgrp docker
```

### Supervisord "unix_http_server" authentication warning
If you see this warning in the Pterodactyl Panel logs:
```
CRIT server 'unix_http_server' running without any HTTP authentication checking
```

**This is safe to ignore for Docker deployments.** The warning indicates that Supervisord (which manages PHP-FPM and Nginx processes inside the container) doesn't have authentication configured for its Unix socket. However:

- The socket is only accessible **inside the container** (not from the host)
- Docker provides network isolation, so this doesn't pose a security risk
- This is a common pattern in containerized applications

The panel will function normally despite this warning. If you want to suppress it (optional), you would need to mount a custom `supervisord.conf` file, but this is not necessary for a secure deployment.

### Authentik "registry: denied" error
If you see a "registry: denied" error when trying to start Authentik:

**This has been fixed** by updating the configuration to use the official `authentik/server` image from Docker Hub (see [Docker Hub](https://hub.docker.com/r/authentik/server)). The new configuration also includes the required PostgreSQL and Redis services that Authentik needs.

**If you still see the error:**
1. Make sure you've updated your `docker-compose.yml` file with the latest version
2. Pull the new images: `docker compose pull authentik authentik-postgres authentik-redis`
3. Make sure your `.env` file includes `AUTHENTIK_DB_PASSWORD` and `AUTHENTIK_REDIS_PASSWORD` (run the setup script again if needed)
4. Start Authentik: `docker compose up -d authentik-postgres authentik-redis authentik`

### Authentik "exited with code 0" (restarting loop)
If Authentik is exiting with code 0 and continuously restarting:

**This has been fixed** by adding `command: server` to the Authentik service in `docker-compose.yml`. The container needs an explicit command to run the server process.

**If you still see the issue:**
1. Make sure your `docker-compose.yml` includes `command: server` in the `authentik` service
2. Restart Authentik: `docker compose restart authentik`
3. Check logs: `docker compose logs -f authentik` to see if the server is starting properly
4. Verify environment variables are set correctly (especially `AUTHENTIK_SECRET_KEY`)

### Authentik "Permission denied: /media/public" error
If you see `PermissionError: [Errno 13] Permission denied: '/media/public'`:

**This has been fixed** by adding `user: root` to the Authentik service in `docker-compose.yml` and pre-creating the required directories.

**To fix this:**
1. Stop Authentik: `docker compose stop authentik`
2. Create the required directories with proper permissions:
   ```bash
   cd ~/homelab/node1
   mkdir -p authentik/media/public authentik/media/private authentik/certs authentik/custom-templates
   chmod -R 777 authentik/media authentik/certs authentik/custom-templates
   ```
3. Make sure your `docker-compose.yml` includes `user: root` in the `authentik` service (already added)
4. Start Authentik: `docker compose up -d authentik`
5. Check logs: `docker compose logs -f authentik` to verify it's working

**Note:** Running as root is acceptable for a homelab environment. For production, you'd want to use a specific user ID.

### Homepage "Host validation failed" error
If you see errors like `Host validation failed for: 192.168.1.88:3000`:

**This has been fixed** by adding `HOMEPAGE_ALLOWED_HOSTS` environment variable to the Homepage service in `docker-compose.yml`.

**Important:** Homepage requires the port number in the host format (e.g., `192.168.1.10:3000`, not just `192.168.1.10`).

**If you still see the issue:**
1. Make sure your `docker-compose.yml` includes the `HOMEPAGE_ALLOWED_HOSTS` environment variable with ports
2. If accessing from a different IP, add it to your `.env` file or update `docker-compose.yml` with the port:
   ```bash
   HOMEPAGE_ALLOWED_HOSTS=localhost:3000,127.0.0.1:3000,YOUR_IP:3000
   ```
3. Restart Homepage: `docker compose restart homepage`
4. The default configuration includes common IPs with port 3000, but you may need to add your specific IP with the port

### Authentik "Not Found" / Missing Default Authentication Flow
If you see a "Not Found" error when accessing Authentik at `http://YOUR_IP:9000/flows/-/default/authentication/`:

**This is normal for a fresh Authentik installation.** The default authentication flow needs to be created. You need to create an admin user first.

**To fix this:**

1. **Create an admin group and user:**
   ```bash
   cd ~/homelab/node1
   
   # Step 1: Access Django shell
   docker compose exec authentik ak shell
   ```
   
   Then in the Python shell, copy and paste this entire block at once:
   ```python
   from authentik.core.models import User
   import secrets
   import string
   
   # Set username to admin
   username = "admin"
   email_input = input("Email (optional, press Enter to skip): ")
   
   # Generate a strong password (32 characters with letters, digits, and special chars)
   alphabet = string.ascii_letters + string.digits + "!@#$%^&*"
   password = ''.join(secrets.choice(alphabet) for i in range(32))
   
   # Create the user
   user = User.objects.create_user(
       username=username,
       email=email_input if email_input else "",
       password=password
   )
   
   # Make sure the user is active
   user.is_active = True
   user.save()
   
   print(f"✅ Created user: {user.username}")
   print(f"🔑 Generated password: {password}")
   print("⚠️  IMPORTANT: Save this password now! It won't be shown again.")
   exit()
   ```
   
   **Important:** Copy and paste the entire code block at once. Don't run it line by line, as errors in one line will prevent subsequent lines from executing.
   
   ```bash
   # Step 2: Add user to admin group (replace 'admin' with your username)
   docker compose exec authentik ak create_admin_group admin
   ```
   
   This will:
   - Create a user account with the credentials you provide
   - Create the admin group (if it doesn't exist)
   - Add the user to the admin group
   
   **Note:** Authentik 2025.10+ has disabled `createsuperuser`. Use the Django shell method above to create your first admin user.

2. **Access the admin interface:**
   - Go to: `http://YOUR_IP:9000/if/admin/`
   - Log in with the admin credentials you just created

3. **Set up the default authentication flow:**
   - In the admin interface, go to **Flows** → **Instances**
   - Click **Create** to create a new flow
   - Name it "default-authentication" (or similar)
   - Add authentication stages (e.g., password authentication)
   - Save the flow

4. **Configure the default flow:**
   - Go to **Settings** → **Brands**
   - Edit your brand
   - Set the **Default authentication flow** to the flow you just created
   - Save

**Alternative: Use the setup wizard**
- After creating the admin user, try accessing `http://YOUR_IP:9000/if/flow/default-authentication/`
- Or go to `http://YOUR_IP:9000/if/admin/` and use the setup wizard if available

**Note:** The default authentication flow is required for users to log in. Once configured, users will be able to access Authentik's login page.

## Next Steps

Once Node 1 is set up and working:

1. **Test Portainer** - Make sure you can see all containers and manage them
2. **Set up Pterodactyl Panel** - Create your first admin user
3. **Configure Uptime Kuma** - Add monitors for your services
4. **Move to Node 2** - Set up Wings and Servarr stack (requires Panel to be ready)

## Quick Commands Reference

```bash
# View all running containers
docker compose ps

# View logs
docker compose logs -f [service_name]

# Restart a service
docker compose restart [service_name]

# Stop all services
docker compose down

# Start all services
docker compose up -d

# Update containers
docker compose pull
docker compose up -d
```

## Important Notes

- **Save your passwords** - Store the `.env` file securely (it's in .gitignore)
- **Don't expose to internet yet** - Set up firewall rules first
- **Node 2 depends on Node 1** - Wings needs the Panel to be running
- **Portainer is your friend** - Use it to manage everything visually

