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
            }
            
            app_window.show_all ();

            var granite_settings = Granite.Settings.get_default ();
            var gtk_settings = Gtk.Settings.get_default ();

            if (granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK)
                print ("");
            else
                print ("");

            granite_settings.notify["prefers-color-scheme"].connect (() => {
                if (granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK) {
                    File file = File.new_for_path (settings.get_string ("dark-mode-wallpaper"));

                    App.Contractor.set_wallpaper_by_contract (file);
                }
                else{
                    File file = File.new_for_path (settings.get_string ("light-mode-wallpaper"));

                    App.Contractor.set_wallpaper_by_contract (file);
                }
            });
        }
                
        public static int main (string[] args) {
            
            var app = new Application ();
            
            return app.run(args);   
        }
    }
}