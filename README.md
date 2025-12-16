# AirPlaySpeaker

Turn your device into a high-quality AirPlay 2 receiver.

**AirPlaySpeaker** provides a streamlined setup to install `shairport-sync` with metadata support and D-Bus integration, allowing your Raspberry Pi or Linux device to seamlessly integrate with Apple's ecosystem.

## Features

- **AirPlay 2 Support**: Multi-room audio synchronization.
- **Metadata Display**: Album art, track title, and artist info via D-Bus (ready for dashboard integrations).
- **Automatic Recovery**: Helper scripts to maintain connection stability.
- **Easy Installation**: Automated script to handle dependencies and compilation.

## Quick Start (Raspberry Pi / Debian)

Run the following command in your terminal:

```bash
curl -O https://raw.githubusercontent.com/your-username/AirPlaySpeaker/main/install.sh
chmod +x install.sh
./install.sh
```

_(Note: Replace `your-username` with the actual path once hosted)_

## Manual Installation

If you prefer to install manually, please refer to the `install.sh` script for the complete list of dependencies and build flags used:

1. Update system packages.
2. Install build dependencies (ALSA, avahi, ssl, etc.).
3. Clone and build `shairport-sync` from source with `--sysconfdir=/etc --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-dbus-interface`.
4. Enable the service.

## Compatibility

Please check [compatibility_checklist.md](./compatibility_checklist.md) for a list of supported devices and known issues.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
