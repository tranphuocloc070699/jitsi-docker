# Jitsi Meet Docker Setup

This is a customized Jitsi Meet video conferencing server setup using Docker and Docker Compose with JWT authentication enabled.

## Prerequisites

- Docker Engine (version 20.10 or higher)
- Docker Compose (version 1.29 or higher)
- A server with a public IP address
- Domain name (optional, but recommended for production)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/tranphuocloc070699/jitsi-docker.git
cd jitsi-docker
```

### 2. Navigate to Jitsi Meet Directory

```bash
cd jitsi-meet
```

### 3. Create Environment Configuration

Copy the example environment file and create your own `.env` file:

```bash
cp env.example .env
```

### 4. Configure Environment Variables

Edit the `.env` file and configure the following required variables:

#### Basic Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `CONFIG` | Directory where all configuration will be stored | `/opt/jitsi-meet-cfg` |
| `HTTP_PORT` | Exposed HTTP port (redirects to HTTPS) | `8000` |
| `HTTPS_PORT` | Exposed HTTPS port | `8443` |
| `TZ` | System timezone | `UTC` or `Asia/Ho_Chi_Minh` |
| `PUBLIC_URL` | Public URL for the web service | `https://meeting.example.com` |

#### Network Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `DOCKER_HOST_ADDRESS` | Your server's public IP address | `103.82.36.214` |
| `JVB_ADVERTISE_IPS` | Media IP addresses to advertise by the JVB | `103.82.36.214` |

#### TURN Server Configuration (Required for NAT traversal)

TURN servers help participants behind firewalls/NAT connect to each other.

| Variable | Description | Example |
|----------|-------------|---------|
| `TURN_HOST` | TURN server hostname or IP | `103.82.36.214` |
| `TURN_PORT` | TURN server port | `3478` |
| `TURN_TRANSPORT` | Transport protocol (tcp/udp) | `tcp` |
| `TURNS_HOST` | TURN over TLS hostname or IP | `103.82.36.214` |
| `TURNS_PORT` | TURN over TLS port | `5349` |
| `TURN_USERNAME` | TURN server username | `jitsi` |
| `TURN_PASSWORD` | TURN server password | `YourSecurePassword123` |

#### Authentication Configuration

This setup uses JWT (JSON Web Token) authentication. Only users with valid tokens can create meetings.

| Variable | Description | Example |
|----------|-------------|---------|
| `AUTH_TYPE` | Authentication type | `jwt` |
| `ENABLE_AUTH` | Enable authentication (1=yes, 0=no) | `1` |
| `ENABLE_GUESTS` | Allow guests to join (1=yes, 0=no) | `0` |
| `JICOFO_AUTH_TYPE` | Jicofo authentication type | `jwt` |
| `JICOFO_ENABLE_AUTO_OWNER` | Auto-assign owner to first participant | `1` |

#### JWT Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `JWT_APP_ID` | Application identifier for JWT | `jitsi_app` |
| `JWT_APP_SECRET` | Application secret (keep this secure!) | Generate using `openssl rand -hex 32` |
| `JWT_ACCEPTED_ISSUERS` | Comma-separated list of accepted issuers | `jitsi_app` |
| `JWT_ACCEPTED_AUDIENCES` | Comma-separated list of accepted audiences | `jitsi_app` |

#### Security Passwords

These passwords are used for internal XMPP communication between Jitsi components. Generate strong passwords:

```bash
# Generate passwords automatically
./gen-passwords.sh
```

Or set them manually:

| Variable | Description |
|----------|-------------|
| `JICOFO_AUTH_PASSWORD` | XMPP password for Jicofo client connections |
| `JVB_AUTH_PASSWORD` | XMPP password for JVB client connections |
| `JIGASI_XMPP_PASSWORD` | XMPP password for Jigasi MUC client connections |
| `JIGASI_TRANSCRIBER_PASSWORD` | XMPP password for Jigasi transcriber |
| `JIBRI_RECORDER_PASSWORD` | XMPP recorder password for Jibri |
| `JIBRI_XMPP_PASSWORD` | XMPP password for Jibri client connections |

#### Optional Features

| Variable | Description | Default |
|----------|-------------|---------|
| `ENABLE_COLIBRI_WEBSOCKET` | Enable WebSocket for better performance | `1` |
| `ENABLE_XMPP_WEBSOCKET` | Enable XMPP WebSocket | `1` |
| `ENABLE_CUSTOM_LOGIN` | Enable custom login page | `1` |
| `DEFAULT_LANGUAGE` | Default language code | `vi` (Vietnamese) |

### 5. Generate Security Passwords

Run the password generation script:

```bash
./gen-passwords.sh
```

This will automatically generate and update strong passwords in your `.env` file.

### 6. Start the Services

```bash
docker-compose up -d
```

This will start all required services:
- **web**: Frontend web interface
- **prosody**: XMPP server for signaling
- **jicofo**: Jitsi Conference Focus component
- **jvb**: Jitsi Videobridge for media routing

### 7. Verify Installation

Check if all services are running:

```bash
docker-compose ps
```

All services should show status as "Up".

View logs:

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f web
docker-compose logs -f jvb
```

### 8. Access Your Jitsi Meet Instance

Open your browser and navigate to:
- If using domain: `https://yourdomain.com:8443`
- If using IP: `https://YOUR_SERVER_IP:8443`

**Note**: You'll get a certificate warning if not using Let's Encrypt. You can safely proceed for testing.

## Custom Branding

Custom branding files are stored in the `files` directory:
- `files/logo.png`: Custom logo (13548 bytes)
- `files/bg2.png`: Custom background image (4800653 bytes)

These files are mapped into the web container through volume mounts defined in `docker-compose.yml`.

## Configuration Persistence

All configuration files are stored in the directory specified by `CONFIG` variable (default: `/opt/jitsi-meet-cfg`):
- `web/`: Web interface configuration
- `prosody/`: XMPP server configuration
- `jicofo/`: Conference focus configuration
- `jvb/`: Video bridge configuration

## Managing the Services

### Stop Services
```bash
docker-compose down
```

### Restart Services
```bash
docker-compose restart
```

### Update Jitsi Images
```bash
docker-compose pull
docker-compose up -d
```

### View Container Logs
```bash
docker-compose logs -f [service_name]
```

## JWT Token Generation

Since JWT authentication is enabled, you'll need to generate JWT tokens for users to create meetings.

Example JWT payload structure:
```json
{
  "context": {
    "user": {
      "name": "User Name",
      "email": "user@example.com"
    }
  },
  "aud": "jitsi_app",
  "iss": "jitsi_app",
  "sub": "yourdomain.com",
  "room": "*"
}
```

Use your `JWT_APP_SECRET` to sign the token.

## Troubleshooting

### Port Conflicts
If ports 8000 or 8443 are already in use, change `HTTP_PORT` and `HTTPS_PORT` in `.env` file.

### Connection Issues
1. Verify firewall allows ports:
   - TCP 8000, 8443 (HTTP/HTTPS)
   - UDP 10000 (JVB media)
   - TCP/UDP 3478, 5349 (TURN)

2. Check `DOCKER_HOST_ADDRESS` and `JVB_ADVERTISE_IPS` match your public IP

3. Verify TURN server is accessible

### Services Won't Start
1. Check logs: `docker-compose logs`
2. Ensure all required passwords are set in `.env`
3. Verify no port conflicts with existing services

## Production Deployment

For production use, consider:

1. **SSL/TLS Certificates**: Enable Let's Encrypt or use your own certificates
   ```bash
   ENABLE_LETSENCRYPT=1
   LETSENCRYPT_DOMAIN=meeting.example.com
   LETSENCRYPT_EMAIL=admin@example.com
   ```

2. **Firewall Configuration**: Open required ports only
   - TCP: 80, 443, 8000, 8443
   - UDP: 10000, 3478
   - TCP: 5349

3. **Resource Allocation**: Adjust memory limits for Java components
   ```bash
   JICOFO_MAX_MEMORY=3072m
   VIDEOBRIDGE_MAX_MEMORY=3072m
   ```

4. **Backup**: Regularly backup the `CONFIG` directory

5. **Monitoring**: Set up monitoring for container health and resource usage

## Additional Resources

- [Jitsi Meet Handbook](https://jitsi.github.io/handbook/)
- [Docker Guide](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker)
- [JWT Authentication](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker#authentication-using-jwt-tokens)

## Support

For issues and questions, please check:
- GitHub Repository: https://github.com/tranphuocloc070699/jitsi-docker
- Jitsi Community: https://community.jitsi.org/

## License

This project uses Jitsi Meet, which is licensed under the Apache License 2.0.
