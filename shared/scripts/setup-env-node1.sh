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

# Detect IP address (prefer wired interface over wireless)
detect_ip() {
    # First, try to find wired interfaces (eth0, enp*, en*, ens*)
    WIRED_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
    # Try to get IP from wired interface specifically
    for interface in $(ip link show | grep -oP '(?<=^\d+:\s)(eth\d+|enp\d+s\d+|en\d+|ens\d+)' | grep -v 'lo' | head -1); do
        if [ -n "$interface" ]; then
            WIRED_IP=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
            if [ -n "$WIRED_IP" ] && [ "$WIRED_IP" != "127.0.0.1" ]; then
                echo "$WIRED_IP"
                return 0
            fi
        fi
    done
    
    # If no wired interface found, try wireless (wlan*, wlp*)
    for interface in $(ip link show | grep -oP '(?<=^\d+:\s)(wlan\d+|wlp\d+s\d+)' | head -1); do
        if [ -n "$interface" ]; then
            WIRELESS_IP=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
            if [ -n "$WIRELESS_IP" ] && [ "$WIRELESS_IP" != "127.0.0.1" ]; then
                echo "$WIRELESS_IP"
                return 0
            fi
        fi
    done
    
    # Fallback to hostname -I (gets all IPs)
    ALL_IPS=$(hostname -I | awk '{print $1}')
    if [ -n "$ALL_IPS" ] && [ "$ALL_IPS" != "127.0.0.1" ]; then
        echo "$ALL_IPS"
        return 0
    fi
    
    return 1
}

# Update APP_URL (automatically detect IP or use default)
NODE_IP=$(detect_ip)
if [ -z "$NODE_IP" ]; then
    echo "⚠️  Could not detect IP address automatically"
    echo "Please manually set APP_URL in .env file"
    NODE_IP="127.0.0.1"
else
    echo "✅ Detected IP address: $NODE_IP"
fi
sed -i "s|APP_URL=.*|APP_URL=http://$NODE_IP|g" .env

# Set AUTHENTIK_URL (same as APP_URL but with port 9000)
if [ -n "$NODE_IP" ]; then
    AUTHENTIK_URL="http://${NODE_IP}:9000"
fi
# Update or add AUTHENTIK_URL
if grep -q "AUTHENTIK_URL=" .env; then
    sed -i "s|AUTHENTIK_URL=.*|AUTHENTIK_URL=${AUTHENTIK_URL}|g" .env
else
    # Add it if it doesn't exist
    echo "" >> .env
    echo "# Authentik Configuration" >> .env
    echo "AUTHENTIK_URL=${AUTHENTIK_URL}" >> .env
fi

# Set HOMEPAGE_ALLOWED_HOSTS (include common IPs plus detected IP, with ports)
HOMEPAGE_HOSTS="localhost:3000,127.0.0.1:3000"
if [ -n "$NODE_IP" ]; then
    # Add detected IP with port
    HOMEPAGE_HOSTS="${HOMEPAGE_HOSTS},${NODE_IP}:3000"
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
grep -E "HOMEPAGE_ALLOWED_HOSTS|AUTHENTIK_URL" .env

echo ""
echo "Done! Your Node 1 .env file is ready."
