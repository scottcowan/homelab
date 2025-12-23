#!/bin/bash
# Script to generate and set passwords in Node 1 .env file

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    echo "Make sure you're in the ~/homelab/node1 directory"
    echo "First copy the template: cp ../shared/env-template-node1.txt .env"
    exit 1
fi

echo "Generating secure passwords for Node 1..."

# Generate and replace passwords
sed -i "s|DB_PASSWORD=your_db_password_here|DB_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|DB_ROOT_PASSWORD=your_db_root_password_here|DB_ROOT_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|REDIS_PASSWORD=your_redis_password_here|REDIS_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|AUTHENTIK_SECRET_KEY=generate_random_key_here|AUTHENTIK_SECRET_KEY=$(openssl rand -base64 32)|g" .env
sed -i "s|AUTHENTIK_DB_PASSWORD=your_authentik_db_password_here|AUTHENTIK_DB_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|AUTHENTIK_REDIS_PASSWORD=your_authentik_redis_password_here|AUTHENTIK_REDIS_PASSWORD=$(openssl rand -base64 32)|g" .env

# Generate APP_KEY for Pterodactyl Panel (base64 format)
APP_KEY_VALUE="base64:$(openssl rand -base64 32)"
sed -i "s|APP_KEY=base64:generate_app_key_here|APP_KEY=${APP_KEY_VALUE}|g" .env

# Update APP_URL (automatically detect IP or use default)
NODE_IP=$(hostname -I | awk '{print $1}')
if [ -z "$NODE_IP" ]; then
    NODE_IP=""
    echo "Could not detect IP, using default: $NODE_IP"
fi
sed -i "s|APP_URL=.*|APP_URL=http://$NODE_IP|g" .env

# Set HOMEPAGE_ALLOWED_HOSTS (include common IPs plus detected IP)
HOMEPAGE_HOSTS="localhost,127.0.0.1"
if [ "$NODE_IP" != "" ]; then
    # Add detected IP if it's different from default
    HOMEPAGE_HOSTS="${HOMEPAGE_HOSTS},${NODE_IP}"
fi

# Update or add HOMEPAGE_ALLOWED_HOSTS
if grep -q "HOMEPAGE_ALLOWED_HOSTS=" .env; then
    sed -i "s|HOMEPAGE_ALLOWED_HOSTS=.*|HOMEPAGE_ALLOWED_HOSTS=${HOMEPAGE_HOSTS}|g" .env
else
    # Add it if it doesn't exist
    echo "" >> .env
    echo "# Homepage Configuration" >> .env
    echo "HOMEPAGE_ALLOWED_HOSTS=${HOMEPAGE_HOSTS}" >> .env
fi

echo "✅ Node 1 passwords generated and .env file updated!"
echo ""
echo "Updated values (partial display):"
grep -E "PASSWORD|SECRET_KEY|APP_URL|APP_KEY" .env | sed 's/=.*/=***hidden***/'
echo ""
echo "Configuration values:"
grep -E "HOMEPAGE_ALLOWED_HOSTS" .env

echo ""
echo "Done! Your Node 1 .env file is ready."
