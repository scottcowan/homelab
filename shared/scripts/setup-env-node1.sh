#!/bin/bash
# Script to generate and set passwords in Node 1 .env file

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    echo "Make sure you're in the ~/homelab/node1 directory"
    exit 1
fi

echo "Generating secure passwords and updating .env file..."

# Generate and replace passwords
sed -i "s|DB_PASSWORD=your_db_password_here|DB_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|DB_ROOT_PASSWORD=your_db_root_password_here|DB_ROOT_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|REDIS_PASSWORD=your_redis_password_here|REDIS_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|AUTHENTIK_SECRET_KEY=generate_random_key_here|AUTHENTIK_SECRET_KEY=$(openssl rand -base64 32)|g" .env

# Update APP_URL (automatically detect IP or use default)
NODE_IP=$(hostname -I | awk '{print $1}')
if [ -z "$NODE_IP" ]; then
    NODE_IP="192.168.1.10"
    echo "Could not detect IP, using default: $NODE_IP"
fi
sed -i "s|APP_URL=.*|APP_URL=http://$NODE_IP|g" .env

echo "✅ Passwords generated and .env file updated!"
echo ""
echo "Updated values (partial display):"
grep -E "PASSWORD|SECRET_KEY|APP_URL" .env | sed 's/=.*/=***hidden***/'

echo ""
echo "Done! Your .env file is ready."

