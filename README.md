# pi-hole-docker-deploy
# Docker Setup and Stack Deployment for Portainer and Pi-hole

This project simplifies Docker installation on Ubuntu Server 24.04.1, manages conflicts, and deploys Docker-based applications using Docker Compose. It includes deployment scripts for Portainer (a container management UI) and Pi-hole (a network-wide ad blocker) with custom configurations.

---

## Prerequisites

- **OS**: Ubuntu Server 24.04.1
- **Permissions**: Administrative (sudo) access to install and manage packages

## Project Structure

- **Docker-install.sh**: Installs Docker and its dependencies.
- **deploy-stacks.sh**: Deploys Docker stacks for Portainer and Pi-hole.
- **docker-compose.yml**: Contains configuration for running Portainer and Pi-hole with Docker Compose.

---

## Installation Instructions

### Step 1: Run `Docker-install.sh`

This script handles Docker installation on Ubuntu Server, removing any conflicting packages, setting up Docker's repository, and installing the latest version of Docker.

Run the script with:

```bash
chmod +x Docker-install.sh
./Docker-install.sh
```

#### Script Details

- **Package Removal**: Removes pre-existing Docker packages that may conflict with Docker’s official version.
- **GPG Key Addition**: Adds Docker’s GPG key and repository.
- **Docker Installation**: Installs `docker-ce`, `docker-compose`, and essential components.
- **Port Conflict Check**: Checks for services using port 53. To stop a conflicting service, use:
  ```bash
  systemctl disable <service_name>
  systemctl stop <service_name>
  ```

### Step 2: Deploy Stacks with `deploy-stacks.sh`

This script deploys Docker stacks for Portainer and Pi-hole. Ensure Docker Compose files are in the specified directories.

Run the script as follows:

```bash
chmod +x deploy-stacks.sh
./deploy-stacks.sh
```

---

## Docker Compose Configuration

### Portainer Configuration (`portainer/docker-compose.yml`)

- **Container Name**: `portainer`
- **Image**: `portainer/portainer-ce:2.21.1`
- **Ports**: Exposes port `9000` for the Portainer web UI.
- **Volumes**:
  - `/var/run/docker.sock`: For Docker communication
  - `/opt/portainer_data`: Persistent storage for Portainer data
- **Environment Variables**:
  - `AGENT_SECRET`: Secure communication between Portainer and the agent.
- **Network**: Uses `agent_network` for container communication.

### Portainer Agent Configuration (`agent` service)

- **Container Name**: `portainer_agent`
- **Image**: `portainer/agent:2.21.1`
- **Ports**: Exposes port `9001` for agent communication.
- **Volumes**:
  - `/var/run/docker.sock`: For Docker communication
  - `/var/lib/docker/volumes`: Persistent Docker volume management
- **Environment Variables**:
  - `AGENT_CLUSTER_ADDR`: Address for agent cluster communication.
  - `AGENT_SECRET`: Must match the server's `AGENT_SECRET`.
- **Network**: Connected to `agent_network`.

---

### Accessing the Portainer Interface

Once Portainer is running, you can access its web UI by visiting [http://host_ip:9000](http://host_ip:9000), replacing `host_ip` with your server’s IP address.

---

Let me know if there's anything else you need!

### Pi-hole Configuration (`pi-hole/docker-compose.yml`)

- **Container Name**: `pi-hole`
- **Image**: `pihole/pihole:latest`
- **Environment Variables**:
  - `TZ`: Set to `America/Araguaina` (adjust as needed).
  - `WEBPASSWORD`: Password for the Pi-hole admin interface.
  - `DNS1`, `DNS2`: Primary and secondary DNS servers (Cloudflare DNS is set by default).
  - `IPv6`: Disabled for simplicity.
  - `DNSMASQ_LISTENING`: Set to `all` to allow DNS requests from any network.
  - `DNSMASQ_USER`: Set to `root`.
- **Volumes**:
  - `/opt/config/pihole`: Persistent storage for Pi-hole configuration.
  - `/opt/config/dnsmasq.d`: Persistent storage for DNSMasq configurations.
- **Network Mode**: Set to `host` for Pi-hole, eliminating the need for port specifications as it uses the default port (80).
- **Capabilities**:
  - `NET_ADMIN`: Grants Pi-hole administrative network privileges to manage DNS services.

#### Accessing the Pi-hole Interface

Once Pi-hole is running, you can access its admin interface by visiting [http://host_ip/admin/](http://host_ip/admin/), replacing `host_ip` with your server’s IP address.

### Networks

- **agent_network**: Configured with a bridge driver for container communication.

### Volumes

- **portainer_data**: A Docker-managed volume to persist Portainer data.

---

## Troubleshooting

1. **Port Conflicts**: If issues arise with port 53, stop the conflicting service as shown above.
2. **Docker Installation Errors**: Check system packages and GPG keys.
3. **Docker Compose Deployment Errors**: Confirm the directory structure matches expected paths for Docker Compose files (`portainer/docker-compose.yml`, `pi-hole/docker-compose.yml`).

---

## License

This project is licensed under the GPL-3.0 license.

--- 

Feel free to modify paths and configurations based on your environment and project needs.