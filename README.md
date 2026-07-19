# useful-scripts

A collection of handy scripts for Linux server and desktop management.

## Quick Install

```bash
curl -fsSL https://git.moraviel.dev/oss/useful-scripts/install.sh | sh
```

The installer will ask whether you want **server** or **desktop** scripts and a device name for the welcome message.

## Scripts

### Server

| Script             | Description |
|--------------------|-------------|
| `welcome` | Show the MOTD welcome screen |                                                                       |
| `nginx-template`   | Generate an nginx site config — `nginx-template <service> <domain> <port>` |
| `services-show`    | Show running Docker containers (name, command, status, ports) |
| `services-Su`      | Pull latest images and restart all Docker Compose services in `/opt/configs` |
| `startAllServices` | Start all Docker Compose services in `/opt/configs` |
| `stopAllServices`  | Stop all Docker Compose services in `/opt/configs` |
| `system-Su`        | Run `apt update && apt upgrade && apt autoremove` |

### Desktop

| Script | Description |
|--------|-------------|
| `welcome` | Show the MOTD welcome screen |
| `system-Su` | Run `apt update && apt upgrade && apt autoremove` |

## MOTD

The installer creates `/etc/update-motd.d/01-welcome` — a dynamic message-of-the-day
that displays uptime, active sessions, CPU load, and RAM usage with a cute Tux cow.
