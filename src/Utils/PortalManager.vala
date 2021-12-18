namespace PortalManager {
     const string DBUS_DESKTOP_PATH = "/org/freedesktop/portal/desktop";
     const string DBUS_DESKTOP_NAME = "org.freedesktop.portal.Desktop";
     Background? background = null;

     public static string generate_token () {
         return "%s_%i".printf (
             GLib.Application.get_default ().application_id.replace (".", "_"),
             Random.int_range (0, int32.MAX)
         );
     }

     [DBus (name = "org.freedesktop.portal.Background")]
     interface Background : Object {
         public abstract uint version { get; }

         public static Background @get () throws IOError, DBusError {
             if (background == null) {
                 var connection = GLib.Application.get_default ().get_dbus_connection ();
                 background = connection.get_proxy_sync<Background> (DBUS_DESKTOP_NAME, DBUS_DESKTOP_PATH);
             }

             return background;
         }

         public abstract ObjectPath request_background (string window_handle, HashTable<string, Variant> options) throws IOError, DBusError;
     }
 }
