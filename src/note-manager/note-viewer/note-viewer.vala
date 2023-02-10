namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-manager/note-viewer/note-viewer.ui")]
    public class NoteViewer : Gtk.Box {
        [GtkChild] public unowned Gtk.Button backbutton;

        public signal void back_clicked ();

        public NoteViewer (Quicknote.Note note) {
            var notewithtoolbar = new Quicknote.NoteWithToolbar(note);
            notewithtoolbar.textview.top_margin = 30;
            notewithtoolbar.textview.left_margin = 40;
            notewithtoolbar.textview.right_margin = 40;
            notewithtoolbar.textview.bottom_margin = 40;
            this.append(notewithtoolbar);
            backbutton.clicked.connect (() => {
                back_clicked();
            });
        }
    }
}

