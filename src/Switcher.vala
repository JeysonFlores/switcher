namespace Switcher {
    
    public class Application : Gtk.Application {
        
        public Application () {
            Object (application_id: "com.github.jeysonflores.switcher",
            flags: ApplicationFlags.FLAGS_NONE);
        }
        
        protected override void activate () {
                        
            var app_window = new MainWindow (this);
            
            app_window.show_all ();
        }
                
        public static int main (string[] args) {
            
            var app = new Application ();
            
            return app.run(args);   
        }
    }
}
