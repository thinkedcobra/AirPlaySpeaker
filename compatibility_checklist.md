# Compatibility & Known Issues Checklist

This document tracks tested devices and known quirks for AirPlaySpeaker.

## Supported Devices

| Device                | OS                                  | Status      | Notes                                                                         |
| --------------------- | ----------------------------------- | ----------- | ----------------------------------------------------------------------------- |
| Raspberry Pi Zero 2 W | Raspberry Pi OS (Bullseye/Bookworm) | ✅ Verified | Performance is excellent. WiFi power saving may need disabling for stability. |
| Raspberry Pi 4        | Raspberry Pi OS                     | ✅ Verified | Overkill for just audio, but works perfectly.                                 |
| Raspberry Pi 3B+      | Raspberry Pi OS                     | ✅ Verified | Solid performance.                                                            |
| Generic Linux x86_64  | Ubuntu 22.04 LTS                    | ⚠️ Beta     | Works, but audio output configuration varies by hardware.                     |

## Not Supported / Experimental

| Device         | OS            | Status | Notes                                                                                                            |
| -------------- | ------------- | ------ | ---------------------------------------------------------------------------------------------------------------- |
| Windows Native | Windows 10/11 | ❌ No  | `shairport-sync` is Linux-centric. Use WSL2 (Experimental) or VirtualBox, though audio passthrough can be laggy. |
| macOS          | macOS         | ❌ No  | macOS has native AirPlay Receiver mode (Monterey+). Use that instead.                                            |

## Known Issues

### 1. WiFi Dropouts (Raspberry Pi)

**Symptom**: Music stops randomly after 10-20 minutes.
**Fix**: Disable WiFi power management.

```bash
sudo iwconfig wlan0 power off
```

_The installer script attempts to configure this automatically._

### 2. Audio Stuttering

**Symptom**: Audio glitching or stuttering.
**Possible Causes**:

- Weak WiFi signal.
- CPU throttling (rare on audio only).
- Output device sample rate mismatch.
  **Fix**: Ensure your power supply is sufficient and try connecting via Ethernet to rule out WiFi issues.

### 3. "Device Already In Use" Error

**Symptom**: Service fails to start.
**Fix**: Ensure no other audio service is hogging the ALSA device.
