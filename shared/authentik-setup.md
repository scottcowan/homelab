# Authentik Setup Guide

[Authentik](https://goauthentik.io/) is an open-source identity provider that provides authentication, authorization, and user management.

**Note:** This guide uses Authentik 2024.10, which is a stable version. Version 2025.10+ has breaking changes that make initial setup more difficult.

## Initial Setup

### Step 1: Create Admin User

After starting Authentik for the first time, you need to create an admin user. In Authentik 2024.10, you can use the standard `createsuperuser` command.

**Option A: Use createsuperuser (Recommended for 2024.10)**

In Authentik 2024.10, you can use the standard `createsuperuser` command:

```bash
cd ~/homelab/node1
docker compose exec authentik ak createsuperuser
```

Follow the prompts to create your admin user:
- Username: `admin` (or your preferred username)
- Email: (optional)
- Password: (enter a strong password)

**Option B: Use Django Shell (If createsuperuser doesn't work)**

If `createsuperuser` doesn't work, use Django's shell:

```bash
cd ~/homelab/node1
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
user = User.objects.create_superuser(
    username=username,
    email=email_input if email_input else "",
    password=password
)

print(f"✅ Created user: {user.username}")
print(f"🔑 Generated password: {password}")
print("⚠️  IMPORTANT: Save this password now! It won't be shown again.")
exit()
```

**Important:** Copy and paste the entire code block at once. Don't run it line by line, as errors in one line will prevent subsequent lines from executing.

**Option B: Try Setup Wizard**

Some Authentik versions have a setup wizard. Try accessing:

1. Go to: `http://YOUR_IP:9000/if/flow/initial-setup/` or `http://YOUR_IP:9000/if/admin/`
2. If a setup wizard appears, follow the prompts to create your first admin user

**Option C: Use Django Shell (Recommended if createsuperuser fails)**

If `createsuperuser` doesn't work (it's disabled in Authentik 2025.10), use Django's shell:

```bash
cd ~/homelab/node1
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

Then add to admin group:
```bash
docker compose exec authentik ak create_admin_group admin
```

Replace `admin` with the username you created.

### Step 2: Access Admin Interface

1. **First, try the initial setup flow** (if you haven't already):
   - Go to: `http://YOUR_IP:9000/if/flow/initial-setup/`
   - This may help configure the default authentication flow automatically

2. **Access the admin interface:**
   - Go to: `http://YOUR_IP:9000/if/admin/`
   - Log in with the admin credentials you just created
   - Username: `admin`
   - Password: (the generated password from Step 1)

### Step 3: Configure Default Authentication Flow

The default authentication flow is required for users to log in. Here's how to set it up:

#### Option A: Use Initial Setup Flow (Recommended)

Authentik provides an initial setup flow that can automatically configure the default authentication flow. Try this first:

1. **Before logging in**, navigate to: `http://YOUR_IP:9000/if/flow/initial-setup/`
   - Replace `YOUR_IP` with your server's IP (e.g., `192.168.1.88`)
   - Example: `http://192.168.1.88:9000/if/flow/initial-setup/`
2. If the setup wizard appears, follow the prompts to create your first admin user and configure flows
3. This will automatically set up:
   - Default authentication flow
   - Default enrollment flow (for new user registration)
   - Default recovery flow (for password reset)

**Note:** If you've already created an admin user via Django shell, you may need to log in first at `http://YOUR_IP:9000/if/admin/` and then manually configure the flow (see Option B below).

#### Option B: Manual Setup

1. **Create Authentication Flow:**
   - Go to **Flows** → **Instances** in the admin interface
   - Click **Create**
   - Name: `default-authentication`
   - Designation: `authentication`
   - Click **Create**

2. **Add Authentication Stage:**
   - In the flow you just created, click **Add Stage**
   - Select **Password Stage** (or **Identification Stage** + **Password Stage**)
   - Configure the stage:
     - Name: `default-password`
     - Password field: `password`
     - Click **Create**

3. **Set as Default:**
   - Go to **Settings** → **Brands**
   - Edit your brand (usually "authentik" or "default")
   - Set **Default authentication flow** to the flow you just created
   - Click **Update**

### Step 4: Test Authentication

1. Log out of the admin interface
2. Go to: `http://YOUR_IP:9000/`
3. You should see the login page
4. Try logging in with your admin credentials

## Common Configuration

### Creating Users

1. Go to **Users** → **Users** in the admin interface
2. Click **Create**
3. Fill in:
   - Username
   - Email
   - Name
   - Password (or let user set it on first login)
4. Click **Create**

### Creating Applications

1. Go to **Applications** → **Providers**
2. Click **Create**
3. Choose provider type (e.g., **OAuth2/OpenID Provider**)
4. Configure:
   - Name
   - Client ID (auto-generated)
   - Client Secret (auto-generated)
   - Redirect URIs (where users will be sent after authentication)
5. Click **Create**

6. **Create Application:**
   - Go to **Applications** → **Applications**
   - Click **Create**
   - Name: Your application name
   - Provider: Select the provider you just created
   - Launch URL: Where to redirect after authentication
   - Click **Create**

### Setting Up SSO for Services

To use Authentik for single sign-on (SSO) with your services:

1. **Create a Provider** (see above)
2. **Create an Application** (see above)
3. **Configure your service** to use OAuth2/OpenID Connect:
   - Authorization URL: `http://YOUR_IP:9000/application/o/authorize/`
   - Token URL: `http://YOUR_IP:9000/application/o/token/`
   - User Info URL: `http://YOUR_IP:9000/application/o/userinfo/`
   - Client ID: From your provider
   - Client Secret: From your provider

## Troubleshooting

### "Not Found" Error on Login Page

If you see "Not Found" when trying to access the login page (`/flows/-/default/authentication/`):

1. **Try the initial setup flow first:**
   - Navigate to: `http://YOUR_IP:9000/if/flow/initial-setup/`
   - This may automatically configure the default authentication flow

2. **If that doesn't work, manually configure:**
   - Make sure you've created the default authentication flow (see Step 3 above)
   - Verify the flow is set as default in **Settings** → **Brands** → Edit your brand → **Default authentication flow**

3. **Check Authentik logs:**
   ```bash
   docker compose logs authentik
   ```

**Reference:** [Setting up Authentik for the first time](https://thomaswildetech.com/blog/2025/02/21/setting-up-authentik-for-the-first-time/)

### Can't Access Admin Interface

1. Make sure Authentik is running: `docker compose ps authentik`
2. Check logs for errors: `docker compose logs authentik`
3. Verify you can access the base URL: `http://YOUR_IP:9000/`
4. Try accessing admin directly: `http://YOUR_IP:9000/if/admin/`

### Permission Errors

If you see permission errors in the logs:

1. Make sure directories exist and have correct permissions:
   ```bash
   cd ~/homelab/node1
   mkdir -p authentik/media/public authentik/media/private authentik/certs authentik/custom-templates
   chmod -R 777 authentik/media authentik/certs authentik/custom-templates
   ```

2. Restart Authentik: `docker compose restart authentik`

### Outpost Warnings

If you see warnings like "No providers assigned to this outpost":

- This is normal if you haven't configured any applications yet
- Outposts are used for reverse proxy authentication
- You can ignore this warning until you set up applications that need it

## Useful Commands

# Access Django shell (to create users)
docker compose exec authentik ak shell

# Add user to admin group (user must exist first)
docker compose exec authentik ak create_admin_group USERNAME

# Change user password
docker compose exec authentik ak changepassword USERNAME

# Check available commands
docker compose exec authentik ak help

# Check Authentik version
docker compose exec authentik ak version

# View logs
docker compose logs -f authentik

# Restart Authentik
docker compose restart authentik
```

## Documentation

- **Official Docs**: https://goauthentik.io/docs/
- **Docker Setup**: https://goauthentik.io/docs/installation/docker-compose/
- **Flow Configuration**: https://goauthentik.io/docs/flow/
- **Application Setup**: https://goauthentik.io/docs/providers/oauth2/

## Next Steps

Once Authentik is set up:

1. **Create users** for your team
2. **Set up applications** for services you want to protect with SSO
3. **Configure flows** for authentication, enrollment, and recovery
4. **Set up outposts** if you need reverse proxy authentication
5. **Integrate with services** like Pterodactyl, Grafana, etc.

