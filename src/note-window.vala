namespace Quicknote {
    [GtkTemplate (ui="/io/github/leolost2605/quicknote/ui/note-window.ui")]
    public class Notewindow : Adw.ApplicationWindow {
        [GtkChild] public unowned Gtk.Box viewbox;
        [GtkChild] public unowned Gtk.Entry titleentry;
        Quicknote.Note note;

        public Notewindow (Gtk.Application app) {
            Object (
                application: app
            );
            var titlebuffer = titleentry.get_buffer();
            titlebuffer.set_text((uint8[])"Untitled note".to_utf8());
            titleentry.set_alignment(0.5f);
            note = new Quicknote.Note ();
            viewbox.append(note);

            this.close_request.connect (() => {
                note.save_note(titleentry.get_text());
                return false;
            });
        }


    }
}
