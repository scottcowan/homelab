#!/bin/bash
# Script to set up Node 2 .env file

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    echo "Make sure you're in the ~/homelab/node2 directory"
    echo "First copy the template: cp ../shared/env-template-node2.txt .env"
    exit 1
fi

echo "Setting up Node 2 .env file..."
echo ""
echo "⚠️  IMPORTANT: You need to get the WINGS_TOKEN from Pterodactyl Panel"
echo ""
echo "Steps:"
echo "1. Make sure Node 1 (Pterodactyl Panel) is running"
echo "2. Log into Panel at http://192.168.1.10"
echo "3. Go to: Configuration → Nodes"
echo "4. Create a new node or edit existing"
echo "5. Copy the Wings token"
echo ""
read -p "Have you copied the Wings token? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please get the Wings token first, then run this script again."
    exit 1
fi

echo ""
read -p "Paste the Wings token here: " WINGS_TOKEN

# Update WINGS_TOKEN in .env
sed -i "s|WINGS_TOKEN=your_wings_token_here|WINGS_TOKEN=$WINGS_TOKEN|g" .env

echo ""
echo "✅ Node 2 .env file updated with Wings token!"
echo ""
echo "Verification:"
grep "WINGS_TOKEN" .env | sed 's/=.*/=***hidden***/'

echo ""
echo "Done! Your Node 2 .env file is ready."

