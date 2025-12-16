import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

def on_properties_changed(interface, changed, invalidated):
    if 'Metadata' in changed:
        meta = changed['Metadata']
        # The metadata keys are often:
        # 'minm': Title
        # 'asar': Artist
        # 'asal': Album
        # 'mper': Persistent ID
        
        title = meta.get('minm')
        artist = meta.get('asar')
        album = meta.get('asal')
        
        print(f"--- Metadata Update ---")
        if title: print(f"Title:  {title}")
        if artist: print(f"Artist: {artist}")
        if album: print(f"Album:  {album}")

if __name__ == "__main__":
    print("Listening for AirPlay metadata on D-Bus...")
    try:
        DBusGMainLoop(set_as_default=True)
        bus = dbus.SystemBus()
        obj = bus.get_object('org.gnome.ShairportSync', '/org/gnome/ShairportSync')
        obj.connect_to_signal("PropertiesChanged", on_properties_changed, dbus_interface="org.freedesktop.DBus.Properties")

        loop = GLib.MainLoop()
        loop.run()
    except Exception as e:
        print(f"Error: {e}")
        print("Ensure you are running on the Raspberry Pi and 'python3-dbus' and 'python3-gi' are installed.")
