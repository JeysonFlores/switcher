public class Switcher.MainWindow: Hdy.Window {

    private GLib.Settings settings;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application
        );
    }        
    
    construct {

        Hdy.init ();

        settings = new GLib.Settings ("com.github.jeysonflores.switcher");

        var icon_mode = new Granite.Widgets.ModeButton () {
            margin_left = 120
        };
        icon_mode.append_icon ("ionicons-sun-symbolic", Gtk.IconSize.BUTTON);
        icon_mode.append_icon ("ionicons-moon-symbolic", Gtk.IconSize.BUTTON);

        var settings_button = new Gtk.Button.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.BUTTON) {
            can_focus = false,
            margin_left = 60
        };
        settings_button.get_style_context ().add_class ("toggle");
        settings_button.get_style_context ().remove_class ("image-but");

        settings_button.clicked.connect(() => {
            var dialog = new Switcher.Widgets.SettingsDialog (this);
            dialog.show_all ();
            dialog.add_button ("Close", Gtk.ResponseType.ACCEPT);
            dialog.response.connect ((response_id) => {
                dialog.destroy ();
            });
        });

        var header_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        header_box.pack_start (icon_mode, false, false, 0);
        header_box.pack_start (settings_button, false, false, 0);

        var header = new Hdy.HeaderBar () {
            custom_title = header_box,
            decoration_layout = "close:",
            has_subtitle = false,
            show_close_button = true,
            can_focus = false
        };
        header.get_style_context ().add_class ("flat");

        var deck = new Hdy.Deck () {
            can_swipe_back = true,
            can_swipe_forward = true,
            vhomogeneous = true,
            hhomogeneous = true,
            expand = true,
            transition_type = Hdy.DeckTransitionType.SLIDE
        };

        var light_mode_view = new Switcher.Views.ModeView (false);
        var dark_mode_view = new Switcher.Views.ModeView (true);

        deck.add (light_mode_view);
        deck.add (dark_mode_view);

        deck.notify["transition-running"].connect (() => {
            if (!deck.transition_running) {
                if(deck.visible_child == light_mode_view) {
                    icon_mode.set_active (0);
                    set_dark_mode (false);
                }

                if(deck.visible_child == dark_mode_view) {
                    icon_mode.set_active (1);
                    set_dark_mode (true);
                }
            }
        });

        icon_mode.mode_changed.connect ((widget) => {
            if(icon_mode.selected == 0) {
                deck.visible_child = light_mode_view;
                set_dark_mode (false);
            }

            if(icon_mode.selected == 1) {
                deck.visible_child = dark_mode_view;
                set_dark_mode (true);
            }
        });

        var grid = new Gtk.Grid (){
            column_homogeneous = true,
            expand = true,
            orientation = Gtk.Orientation.VERTICAL
        };
        grid.add (header);
        grid.add (deck);

        icon_mode.set_active (0);

        move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
        resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

        add (grid);
        /* 
        File file = File.new_for_path ("/home/jeyson/Imágenes/a.jpg");
        var contractor = App.Contractor.get_contract ();

        App.Contractor.set_wallpaper_by_contract (file);*/
    }

    public override bool delete_event (Gdk.EventAny event) {   

        if (settings.get_boolean ("persistent")) {
            hide ();
            
            application.hold ();
            
            return true;
        } else {
            int root_x, root_y;
            get_position (out root_x, out root_y);

            int width, height;
            get_size (out width, out height);

            settings.set_int ("window-width", width);
            settings.set_int ("window-height", height);

            settings.set_int ("pos-x", root_x);
            settings.set_int ("pos-y", root_y);
            
            return false;
        }
    }

    private void set_dark_mode (bool flag) {
        var css_provider = new Gtk.CssProvider ();
        var gtk_settings = Gtk.Settings.get_default ();

        if (flag) {
            gtk_settings.gtk_application_prefer_dark_theme = (true);
            css_provider.load_from_resource ("/com/github/jeysonflores/switcher/style-dark.css");
        } else {
            gtk_settings.gtk_application_prefer_dark_theme = (false);
            css_provider.load_from_resource ("/com/github/jeysonflores/switcher/style.css");
        }

        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }
}