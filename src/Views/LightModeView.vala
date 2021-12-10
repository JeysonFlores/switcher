public class Switcher.Views.LightModeView : Gtk.Box {

    public LightModeView () {
        Object(
            orientation: Gtk.Orientation.VERTICAL
        );
    }
    
    construct {
        var title_label = new Gtk.Label ("Select a default wallpaper for Light Mode") {
            margin_top = 20
        };
        title_label.get_style_context ().add_class ("t1");
        
        var pixbuf = new Gdk.Pixbuf.from_file_at_size ("/home/jeyson/Imágenes/a.jpg", 400, 300);

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

        pack_start (title_label, false, false, 0);
        pack_start (image, false, false, 0);
        pack_start (select_wallpaper, false, false, 0);
    }
}