namespace Quicknote {
    [GtkTemplate (ui="/io/github/leolost2605/quicknote/ui/note-window.ui")]
    public class Notewindow : Adw.ApplicationWindow {
        [GtkChild] public unowned Gtk.TextView textview;
        [GtkChild] public unowned Gtk.Button test;
        [GtkChild] public unowned Gtk.Box viewbox;

        public Notewindow (Gtk.Application app) {
            Object (
                application: app
            );
            var toolbar = new Quicknote.Toolbar ();
            viewbox.append(toolbar);
            var buffer = textview.get_buffer ();
            toolbar.bold.clicked.connect (() => {
                Gtk.TextIter start;
                Gtk.TextIter end;
                buffer.get_selection_bounds(out start, out end);
                buffer.create_tag("strike", strikethrough: true);
                buffer.apply_tag_by_name("strike", start, end);
            });
        }
    }
}
