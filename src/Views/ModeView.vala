public class Switcher.Views.ModeView : Gtk.Box {

    private GLib.Settings settings;
    private Gtk.Image image;
    public bool dark_mode { get; construct; }

    public ModeView (bool dark_mode) {
        Object(
            orientation: Gtk.Orientation.VERTICAL,
            dark_mode: dark_mode
        );
    }
    
    construct {

        this.settings = new GLib.Settings ("com.github.jeysonflores.switcher");

        Gtk.Label? title_label = null;
        
        if (this.dark_mode) {
            title_label = new Gtk.Label ("Select a default wallpaper for Dark Mode") {
                margin_top = 20
            };
        } else {
            title_label = new Gtk.Label ("Select a default wallpaper for Light Mode") {
                margin_top = 20
            };
        }
        title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        image = new Gtk.Image () {
            margin_top = 20,
            halign = Gtk.Align.CENTER
        };
        this.refresh_wallpapers ();

        var select_wallpaper = new Gtk.Button () {
            label = "Select image to set as wallpaper",
            margin_top = 30,
            margin_bottom = 60,
            halign = Gtk.Align.CENTER
        };
        select_wallpaper.get_style_context ().add_class ("suggested-action");

        select_wallpaper.clicked.connect(() => {
            var dialog = new Gtk.FileChooserNative ("Select an image", null, Gtk.FileChooserAction.OPEN, "Select", "Cancel");

            var filter = new Gtk.FileFilter ();
            filter.add_pattern ("*.jpg");
            filter.add_pattern ("*.jpeg");
            filter.add_pattern ("*.png");
            filter.add_pattern ("*.svg");

            dialog.add_filter (filter);

            var response = dialog.run ();

            if (response == Gtk.ResponseType.ACCEPT) {
                var key = this.dark_mode ? "dark-mode-wallpaper" : "light-mode-wallpaper";

                this.settings.set_string (key, dialog.get_filename ());
                
                var new_pixbuf = new Gdk.Pixbuf.from_file_at_size (dialog.get_filename (), 400, 300);

                image.set_from_pixbuf (new_pixbuf);

                var granite_settings = Granite.Settings.get_default ();

                if ((granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK) && this.dark_mode) {
                    if (FileUtils.test (dialog.get_filename (), FileTest.EXISTS)) {
                        File file = File.new_for_path (dialog.get_filename ());

                        App.Contractor.set_wallpaper_by_contract (file);
                     }   
                }
                
                else if ((granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.NO_PREFERENCE ) && !this.dark_mode) {
                    if (FileUtils.test (dialog.get_filename (), FileTest.EXISTS)) {
                        File file = File.new_for_path (dialog.get_filename ());

                        App.Contractor.set_wallpaper_by_contract (file);
                     }   
                }
            }
        });

        pack_start (title_label, false, false, 0);
        pack_start (image, false, false, 0);
        pack_start (select_wallpaper, false, false, 0);
    }

    public void refresh_wallpapers() {
        var key = this.dark_mode ? "dark-mode-wallpaper" : "light-mode-wallpaper";
        
        Gdk.Pixbuf? pixbuf = null;

        if (FileUtils.test (this.settings.get_string (key), FileTest.EXISTS)) {
            pixbuf = new Gdk.Pixbuf.from_file_at_size (this.settings.get_string (key), 400, 300);
        } else {
            var resource = ("/com/github/jeysonflores/switcher/" + (this.dark_mode ? "default-dark.png" : "default-light.png"));
            pixbuf = new Gdk.Pixbuf.from_resource_at_scale(resource, 400, 400, true);
        }

        this.image.pixbuf = pixbuf;
    }
}
