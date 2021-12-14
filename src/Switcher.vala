namespace Switcher {
    
    public class Application : Gtk.Application {
        
        public bool no_gui;
        public GLib.Settings settings;

        public Application () {
            Object (application_id: "com.github.jeysonflores.switcher",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE);
        }
        
        protected override void activate () {
            this.settings = new GLib.Settings ("com.github.jeysonflores.switcher");

            var app_window = (MainWindow) get_active_window ();

            if (app_window == null) {
                app_window = new MainWindow (this);
                if (this.no_gui) {
                    this.hold ();
                } else {
                    app_window.show_all ();
                }
            } else {
                if (!this.no_gui) {
                    this.release ();
                    app_window.light_mode_view.refresh_wallpapers ();
                    app_window.dark_mode_view.refresh_wallpapers ();
                    app_window.show_all ();
                    app_window.present ();
                }
            }

            var granite_settings = Granite.Settings.get_default ();

            if (granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK)
                print ("");
            else
                print ("");


            granite_settings.notify["prefers-color-scheme"].connect (() => {

                var wallpaper_location = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK ? settings.get_string ("dark-mode-wallpaper") : settings.get_string ("light-mode-wallpaper");

                if (FileUtils.test (wallpaper_location, FileTest.EXISTS)) {
                    File file = File.new_for_path (wallpaper_location);

                    App.Contractor.set_wallpaper_by_contract (file);
                }
            });
        }

        public override int command_line (ApplicationCommandLine command_line) {

            bool no_gui_mode = false;
            OptionEntry[] options = new OptionEntry[1];
            options[0] = {
                "no-gui", 0, 0, OptionArg.NONE,
                ref no_gui_mode, "Run without window", null
            };

            string[] args = command_line.get_arguments ();
            string[] _args = new string[args.length];
            for (int i = 0; i < args.length; i++) {
                _args[i] = args[i];
            }

            try {
                var ctx = new OptionContext ();
                ctx.set_help_enabled (true);
                ctx.add_main_entries (options, null);
                unowned string[] tmp = _args;
                ctx.parse (ref tmp);
            } catch (OptionError e) {
                command_line.print ("error: %s\n", e.message);
                return 0;
            }

            this.no_gui = no_gui_mode;

            this.activate ();

            return 0;
        }
                
        public static int main (string[] args) {
            
            var app = new Application ();
            
            return app.run(args);   
        }
    }
}