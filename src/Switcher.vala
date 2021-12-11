namespace Switcher {
    
    public class Application : Gtk.Application {
        
        public Application () {
            Object (application_id: "com.github.jeysonflores.switcher",
            flags: ApplicationFlags.FLAGS_NONE);
        }
        
        protected override void activate () {
            var settings = new GLib.Settings ("com.github.jeysonflores.switcher");

            var app_window = get_active_window ();

            if (app_window == null) {
                app_window = new MainWindow (this);
            } else {
                this.release ();
                app_window.present ();
            }
            
            app_window.show_all ();

            var granite_settings = Granite.Settings.get_default ();
            var gtk_settings = Gtk.Settings.get_default ();

            if (granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK)
                print ("");
            else
                print ("");

            print (GLib.Environment.get_user_config_dir ());

            granite_settings.notify["prefers-color-scheme"].connect (() => {

                var wallpaper_location = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK ? settings.get_string ("dark-mode-wallpaper") : settings.get_string ("light-mode-wallpaper");

                if (FileUtils.test (wallpaper_location, FileTest.EXISTS)) {
                    File file = File.new_for_path (wallpaper_location);

                    App.Contractor.set_wallpaper_by_contract (file);
                }
            });
        }

        private void switch_wallpaper (bool dark) {
            var settings = new GLib.Settings ("com.github.jeysonflores.switcher");
        }
                
        public static int main (string[] args) {
            
            var app = new Application ();
            
            return app.run(args);   
        }
    }
}