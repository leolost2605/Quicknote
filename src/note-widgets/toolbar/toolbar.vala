namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-widgets/toolbar/toolbar.ui")]
    public class Toolbar : Gtk.Box {

        [GtkChild] public unowned Gtk.ToggleButton bold;
        [GtkChild] public unowned Gtk.ToggleButton strikethrough;
        [GtkChild] public unowned Gtk.ToggleButton highlight;
        [GtkChild] public unowned Gtk.ToggleButton italic;

        public Toolbar () {
        }
    }
}
