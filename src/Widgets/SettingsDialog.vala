public class Switcher.Widgets.SettingsDialog : Granite.Dialog {

    private GLib.Settings settings;

    public SettingsDialog (Gtk.Window window) {
        Object(
            transient_for: window
        );
    }
    
    construct {
        settings = new GLib.Settings ("com.github.jeysonflores.switcher");

        var title = new Gtk.Label ("Settings") {
            halign = Gtk.Align.CENTER
        };
        title.get_style_context ().add_class ("keycap");

        var run_at_startup_label = new Granite.HeaderLabel ("Run at startup");
        var run_at_startup_description_label = new Gtk.Label ("Set if run or not at startup") {
            halign = Gtk.Align.START
        };
        run_at_startup_description_label.get_style_context ().add_class ("description-label");

        var run_at_startup = new Gtk.Switch () {
            active = settings.get_boolean ("run-at-startup"),
            halign = Gtk.Align.START
        };

        run_at_startup.notify["active"].connect(() => {
            settings.set_boolean ("run-at-startup", run_at_startup.get_active ());
        });

        var persistent_mode_label = new Granite.HeaderLabel ("Persistent mode ");
        var persistent_mode_description_label = new Gtk.Label ("It'll keep running after the app closes"){
            halign = Gtk.Align.START
        };
        persistent_mode_description_label.get_style_context ().add_class ("description-label");

        var persistent_mode = new Gtk.Switch () {
            active = settings.get_boolean ("persistent"),
            halign = Gtk.Align.START
        };

        persistent_mode.notify["active"].connect(() => {
            settings.set_boolean ("persistent", persistent_mode.get_active ());
        });

        var layout = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL,
            margin = 12,
            margin_top = 0,
            row_spacing = 12
        };

        layout.add (title);
        layout.add (run_at_startup_label);
        layout.add (run_at_startup_description_label);
        layout.add (run_at_startup);
        layout.add (persistent_mode_label);
        layout.add (persistent_mode_description_label);
        layout.add (persistent_mode);

        get_content_area ().add (layout);
    }
}