namespace Switcher {
    
    public class Application : Gtk.Application {
        
        public Application () {
            Object (application_id: "com.github.jeysonflores.switcher",
            flags: ApplicationFlags.FLAGS_NONE);
        }
        
        protected override void activate () {
                        
            var app_window = new MainWindow (this);
            
            app_window.show_all ();

            var granite_settings = Granite.Settings.get_default ();
            var gtk_settings = Gtk.Settings.get_default ();

            var css_provider = new Gtk.CssProvider ();

            if (granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK)
                css_provider.load_from_resource ("/com/github/jeysonflores/switcher/style-dark.css");
            else
                css_provider.load_from_resource ("/com/github/jeysonflores/switcher/style.css");

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            gtk_settings.gtk_application_prefer_dark_theme = (
                granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
            );

            granite_settings.notify["prefers-color-scheme"].connect (() => {
                gtk_settings.gtk_application_prefer_dark_theme = (
                    granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
                );

                if (granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK)
                    css_provider.load_from_resource ("/com/github/jeysonflores/switcher/style-dark.css");
                else
                    css_provider.load_from_resource ("/com/github/jeysonflores/switcher/style.css");

                Gtk.StyleContext.add_provider_for_screen (
                    Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
            });
        }
                
        public static int main (string[] args) {
            
            var app = new Application ();
            
            return app.run(args);   
        }
    }
}
