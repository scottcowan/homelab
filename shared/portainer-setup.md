# Portainer Setup Guide

[Portainer](https://github.com/portainer/portainer) is a lightweight Docker management UI that makes it easy to manage your containers, images, volumes, networks, and stacks through a web interface.

## Why Portainer?

Portainer is **highly recommended** for your homelab because it provides:

1. **Visual Container Management** - Start, stop, restart, and manage containers without command line
2. **Log Viewer** - View container logs through a web interface
3. **Resource Monitoring** - See CPU, memory, and network usage for all containers
4. **Volume & Network Management** - Easily manage Docker volumes and networks
5. **Stack Management** - Deploy and manage docker-compose stacks visually
6. **Image Management** - Pull, remove, and manage Docker images
7. **Container Console** - Access container terminals through the web UI

## Access

After starting the Portainer container:
- **HTTP**: http://192.168.1.10:8000
- **HTTPS**: https://192.168.1.10:8443

## Initial Setup

1. **First Login**
   - When you first access Portainer, you'll be prompted to create an admin account
   - Choose a strong password and save it securely

2. **Connect to Docker**
   - Portainer will automatically detect the local Docker socket
   - Select "Docker" as the environment type
   - Click "Connect" to add the local Docker environment

3. **Explore the Interface**
   - **Home**: Overview of all containers, images, volumes, and networks
   - **Containers**: Manage all your running containers
   - **Images**: View and manage Docker images
   - **Volumes**: Manage Docker volumes
   - **Networks**: View and manage Docker networks
   - **Stacks**: Deploy and manage docker-compose stacks

## Managing Your Homelab with Portainer

### View All Containers
- Navigate to **Containers** in the sidebar
- See all containers across all nodes (if you add remote nodes)
- Click on any container to view details, logs, stats, and console

### View Container Logs
1. Go to **Containers**
2. Click on a container name
3. Click the **Logs** tab
4. View real-time logs or download them

### Monitor Resource Usage
1. Go to **Containers**
2. Click on a container name
3. Click the **Stats** tab
4. View CPU, memory, and network usage in real-time

### Manage docker-compose Stacks
1. Go to **Stacks**
2. Click **Add stack**
3. Give it a name (e.g., "servarr-stack")
4. Paste your docker-compose.yml content
5. Click **Deploy the stack**

### Access Container Console
1. Go to **Containers**
2. Click on a container name
3. Click the **Console** tab
4. Execute commands inside the container

### Update Containers
1. Go to **Images**
2. Find the image you want to update
3. Click **Pull** to download the latest version
4. Go to **Containers**
5. Stop the container
6. Click **Duplicate/Edit**
7. Change the image tag to `latest` or the new version
8. Click **Deploy the container**

## Adding Remote Nodes (Advanced)

You can add Node 2 and Node 3 to Portainer for centralized management:

1. On each remote node, install Portainer Agent:
   ```bash
   docker run -d -p 9001:9001 --name portainer_agent --restart=always \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v /var/lib/docker/volumes:/var/lib/docker/volumes \
     portainer/agent:latest
   ```

2. In Portainer UI:
   - Go to **Environments**
   - Click **Add environment**
   - Select **Docker**
   - Enter the remote node IP and port 9001
   - Click **Connect**

## Tips

- **Bookmark Portainer** - It will be one of your most-used tools
- **Use Stacks** - Deploy your docker-compose files as stacks for easier management
- **Monitor Resources** - Regularly check the Stats tab to ensure you're not running out of resources
- **Backup Volumes** - Use Portainer to easily identify which volumes need backing up
- **Quick Actions** - Use the quick action buttons (start, stop, restart) for common tasks

## Security Notes

- Portainer has access to your Docker socket, which gives it full control over Docker
- Keep Portainer updated
- Use strong passwords
- Consider restricting access to Portainer's web interface via firewall rules if exposed to the internet

