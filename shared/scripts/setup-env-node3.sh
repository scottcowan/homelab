#!/bin/bash
# Script to generate and set passwords in Node 3 .env file

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    echo "Make sure you're in the ~/homelab/node3 directory"
    echo "First copy the template: cp ../shared/env-template-node3.txt .env"
    exit 1
fi

echo "Generating secure passwords for Node 3..."

# Generate and replace passwords
sed -i "s|GRAFANA_PASSWORD=your_grafana_password_here|GRAFANA_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|INFLUXDB_PASSWORD=your_influxdb_password_here|INFLUXDB_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|DOCMOST_PASSWORD=your_docmost_password_here|DOCMOST_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|DOCMOST_SECRET_KEY=generate_random_key_here|DOCMOST_SECRET_KEY=$(openssl rand -base64 32)|g" .env
sed -i "s|LINKWARDEN_PASSWORD=your_linkwarden_password_here|LINKWARDEN_PASSWORD=$(openssl rand -base64 32)|g" .env
sed -i "s|LINKWARDEN_SECRET=generate_random_key_here|LINKWARDEN_SECRET=$(openssl rand -base64 32)|g" .env

echo "✅ Node 3 passwords generated and .env file updated!"
echo ""
echo "⚠️  IMPORTANT: INFLUXDB_TOKEN needs to be set after InfluxDB is running"
echo "   1. Start InfluxDB: docker compose up -d influxdb"
echo "   2. Access InfluxDB at http://192.168.1.12:8086"
echo "   3. Complete setup and create API token"
echo "   4. Update .env file with the token"
echo ""
echo "Updated values (partial display):"
grep -E "PASSWORD|SECRET" .env | sed 's/=.*/=***hidden***/'

echo ""
echo "Note: INFLUXDB_TOKEN will be set after InfluxDB setup (see above)"
echo "Done! Your Node 3 .env file is ready (except INFLUXDB_TOKEN)."








