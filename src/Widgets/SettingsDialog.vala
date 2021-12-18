public class Switcher.Widgets.SettingsDialog : Gtk.Popover {

    private GLib.Settings settings;

    public SettingsDialog (Gtk.Widget origin) {
        Object (
            relative_to: origin
        );
    }
    
    construct {
        this.settings = new GLib.Settings ("com.github.jeysonflores.switcher");

        const string run_at_startup_tooltip = "Set if run or not at startup";
        
        var run_at_startup_label = new Gtk.Label ("Run at startup:") {
            halign = Gtk.Align.END,
            tooltip_text = run_at_startup_tooltip
        };

        var run_at_startup = new Gtk.Switch () {
            active = this.settings.get_boolean ("run-at-startup"),
            halign = Gtk.Align.START,
            tooltip_text = run_at_startup_tooltip
        };

        run_at_startup.notify["active"].connect(() => {

            ask_for_background ();
            
            this.settings.set_boolean ("run-at-startup", run_at_startup.get_active ());

            var desktop_file_name = "com.github.jeysonflores.switcher" + ".desktop";
            var desktop_file_path = new GLib.DesktopAppInfo (desktop_file_name).filename;
            var desktop_file = GLib.File.new_for_path (desktop_file_path);
            var dest_path = GLib.Path.build_path (
                GLib.Path.DIR_SEPARATOR_S,
                GLib.Environment.get_home_dir (),
                ".config",
                "autostart",
                desktop_file_name
            );
            var dest_file = GLib.File.new_for_path (dest_path);
            try {
                desktop_file.copy (dest_file, GLib.FileCopyFlags.OVERWRITE);
            } catch (Error e) {
                warning ("Error making copy of desktop file for autostart: %s", e.message);
            }

            var keyfile = new GLib.KeyFile ();
            try {
                keyfile.load_from_file (dest_path, GLib.KeyFileFlags.NONE);
                keyfile.set_boolean ("Desktop Entry", "X-GNOME-Autostart-enabled", run_at_startup.get_active ());
                keyfile.set_string ("Desktop Entry", "Exec", "flatpak run com.github.jeysonflores.switcher" + " --no-gui");
                keyfile.save_to_file (dest_path);
            } catch (Error e) {
                warning ("Error enabling autostart: %s", e.message);
            }
        });
        
        const string persistent_mode_tooltip = "Keep running after the app closes";
        
        var persistent_mode_label = new Gtk.Label ("Persistent mode:") {
            halign = Gtk.Align.END,
            tooltip_text = persistent_mode_tooltip
        };
        
        var persistent_mode = new Gtk.Switch () {
            active = this.settings.get_boolean ("persistent"),
            halign = Gtk.Align.START,
            tooltip_text = persistent_mode_tooltip
        };

        persistent_mode.notify["active"].connect(() => {
            this.settings.set_boolean ("persistent", persistent_mode.get_active ());
        });

        var layout = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL,
            margin = 12,
            column_spacing = 12,
            row_spacing = 6
        };
        
        layout.attach (run_at_startup_label, 0, 0);
        layout.attach (run_at_startup, 1, 0);
        layout.attach (persistent_mode_label, 0, 1);
        layout.attach (persistent_mode, 1, 1);

        this.add (layout);
    }

    private void ask_for_background () {
        try {
            var portal = PortalManager.Background.get ();
            string[] cmd = { "com.github.jeysonflores.switcher", "--no-gui" };

            var options = new HashTable<string, Variant> (str_hash, str_equal);
            options["handle_token"] = PortalManager.generate_token ();
            options["reason"] = _("Switcher wants to initialize with the session");
            options["commandline"] = cmd;
            options["dbus-activatable"] = false;
            options["autostart"] = true;

            // TODO: handle response
            try {
                portal.request_background ("Switcher", options);
            } catch (Error e) {
                warning ("couldnt ask for background access: %s", e.message);
            }
        } catch (Error e) {
            warning ("cloudnt connect to portal: %s", e.message);
        }
    }
}
