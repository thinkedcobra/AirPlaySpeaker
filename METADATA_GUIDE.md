# Metadata Guide

This guide explains how to verify that AirPlay metadata (Artist, Title, Album Art) is working correctly on your device.

## Prerequisites

Ensure you have installed AirPlaySpeaker using the latest `install.sh`, which includes `libglib2.0-dev` and builds with `--with-dbus-interface`.

## 1. Verify Configuration

Ensure your `/etc/shairport-sync.conf` has metadata enabled:

```conf
metadata =
{
    enabled = "yes";
    include_cover_art = "yes";
};
```

If you changed the config, restart the service:

```bash
sudo systemctl restart shairport-sync
```

## 2. Monitor D-Bus (Real-time Test)

The most reliable way to check if metadata is flowing is to monitor the D-Bus system bus while playing music.

Run this command:

```bash
sudo dbus-monitor --system destination=org.gnome.ShairportSync
```

**What to look for:**
When you play a song, you should see output similar to:

```
signal ... path=/org/gnome/ShairportSync; interface=org.freedesktop.DBus.Properties; member=PropertiesChanged
   string "org.gnome.ShairportSync.RemoteControl"
   array [
      dict entry(
         string "Metadata"
         variant             array [
               dict entry(
                  string "minm"
                  variant                      string "Item Name (Title)"
               )
...
```

## 3. Using Python to Read Metadata

You can use a simple Python script to print metadata as it changes.

Create `test_metadata.py`:

```python
import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

def on_properties_changed(interface, changed, invalidated):
    if 'Metadata' in changed:
        meta = changed['Metadata']
        print(f"Title: {meta.get('minm')}")
        print(f"Artist: {meta.get('asar')}")
        print(f"Album: {meta.get('asal')}")

DBusGMainLoop(set_as_default=True)
bus = dbus.SystemBus()
obj = bus.get_object('org.gnome.ShairportSync', '/org/gnome/ShairportSync')
obj.connect_to_signal("PropertiesChanged", on_properties_changed, dbus_interface="org.freedesktop.DBus.Properties")

loop = GLib.MainLoop()
loop.run()
```

Run it with `python3 test_metadata.py` while playing music.
