namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-widgets/toolbar/toolbar.ui")]
    public class Toolbar : Gtk.Box {

        [GtkChild] public unowned Gtk.Button bold;

        public Toolbar () {

        }
    }
}
