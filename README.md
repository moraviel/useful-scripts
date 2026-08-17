# useful-scripts

A collection of handy scripts for Linux server and desktop management.

## Quick Install

```bash
curl -fsSL https://oss.pages.moraviel.dev/useful-scripts/install.sh | sh
```

The installer will ask whether you want **server** or **desktop** scripts and a device name for the welcome message.
It also auto-detects the package manager (`apt` or `pacman`) on the target machine and installs the matching `system-Su` variant.

## Scripts

### Server

| Script             | Description |
|--------------------|-------------|
| `welcome` | Show the MOTD welcome screen |
| `nginx-template`   | Generate an nginx site config — `nginx-template <service> <domain> <port>` |
| `services-show`    | Show running Docker containers (name, command, status, ports) |
| `services-Su`      | Pull latest images and restart all Docker Compose services in `/opt/configs` |
| `startAllServices` | Start all Docker Compose services in `/opt/configs` |
| `stopAllServices`  | Stop all Docker Compose services in `/opt/configs` |
| `system-Su`        | Update packages — `apt update && apt upgrade && apt autoremove` (Ubuntu/Debian) or `pacman -Syu` + orphan cleanup (Arch) |

### Desktop

| Script | Description |
|--------|-------------|
| `welcome` | Show the MOTD welcome screen |
| `system-Su` | Update packages — `apt update && apt upgrade && apt autoremove` (Ubuntu/Debian) or `pacman -Syu` + orphan cleanup (Arch) |

## MOTD

The installer creates `/etc/update-motd.d/01-welcome` — a dynamic message-of-the-day
that displays uptime, active sessions, CPU load, and RAM usage with a cute Tux cow.
