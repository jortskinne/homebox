# Homebox

A fork of [sysadminsmedia/homebox](https://github.com/sysadminsmedia/homebox) — a home inventory and organization system built for the self-hosted enthusiast.

## Features

- Track and manage your home inventory
- Organize items by location, label, and category
- Attach receipts, manuals, and photos to items
- Track warranties and maintenance schedules
- Self-hosted with a simple Docker deployment
- REST API with Swagger documentation

## Quick Start

### Docker Compose

```yaml
version: '3.8'
services:
  homebox:
    image: ghcr.io/your-org/homebox:latest
    container_name: homebox
    restart: unless-stopped
    environment:
      - HBOX_LOG_LEVEL=info
      - HBOX_LOG_FORMAT=text
      - HBOX_WEB_MAX_UPLOAD_SIZE=50
    volumes:
      - homebox-data:/data/
    ports:
      - 3100:7745

volumes:
  homebox-data:
```

### Development

Requirements:
- Go 1.21+
- Node.js 18+
- Task (taskfile runner)

```bash
# Clone the repository
git clone https://github.com/your-org/homebox.git
cd homebox

# Install dependencies and start development servers
task dev
```

## Configuration

Homebox is configured via environment variables:

| Variable | Default | Description |
|---|---|---|
| `HBOX_LOG_LEVEL` | `info` | Log level (debug, info, warn, error) |
| `HBOX_LOG_FORMAT` | `text` | Log format (text, json) |
| `HBOX_WEB_PORT` | `7745` | Port to listen on |
| `HBOX_WEB_HOST` | `` | Host to bind to |
| `HBOX_WEB_MAX_UPLOAD_SIZE` | `10` | Max upload size in MB |
| `HBOX_STORAGE_DATA` | `./data` | Path to data directory |
| `HBOX_DATABASE_DRIVER` | `sqlite3` | Database driver |
| `HBOX_OPTIONS_ALLOW_REGISTRATION` | `true` | Allow new user registration |

> **Personal note:** I bumped `HBOX_WEB_MAX_UPLOAD_SIZE` to `50` in the Docker Compose example above — the default 10 MB is too small for attaching appliance manuals and warranty PDFs.

> **Personal note:** Once I created my account I set `HBOX_OPTIONS_ALLOW_REGISTRATION=false` so no one else can register on my instance.

## Contributing

Contributions are welcome! Please open an issue or pull request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/my-feature`)
3. Commit your changes
4. Push to the branch and open a Pull Request

## License

AGPL-3.0 — see [LICENSE](LICENSE) for details.
