public class Switcher.Views.LightModeView : Gtk.Box {

    private GLib.Settings settings;

    public LightModeView () {
        Object(
            orientation: Gtk.Orientation.VERTICAL
        );
    }
    
    construct {

        settings = new GLib.Settings ("com.github.jeysonflores.switcher");

        var title_label = new Gtk.Label ("Select a default wallpaper for Light Mode") {
            margin_top = 20
        };
        title_label.get_style_context ().add_class ("t1");
        
        Gdk.Pixbuf? pixbuf = null;

        if (FileUtils.test (settings.get_string ("dark-mode-wallpaper"), FileTest.EXISTS)) {
            pixbuf = new Gdk.Pixbuf.from_file_at_size (settings.get_string ("light-mode-wallpaper"), 400, 300);
        } else {
            // change for default image of /NOT SELECTED/
            pixbuf = new Gdk.Pixbuf.from_file_at_size (settings.get_string ("dark-mode-wallpaper"), 400, 300);
        }

        var image = new Gtk.Image.from_pixbuf (pixbuf) {
            margin_top = 20,
            halign = Gtk.Align.CENTER
        };

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
                settings.set_string ("light-mode-wallpaper", dialog.get_filename ());
                
                var new_pixbuf = new Gdk.Pixbuf.from_file_at_size (dialog.get_filename (), 400, 300);

                image.set_from_pixbuf (new_pixbuf);
            }
        });

        pack_start (title_label, false, false, 0);
        pack_start (image, false, false, 0);
        pack_start (select_wallpaper, false, false, 0);
    }
}