namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-widgets/note-with-toolbar.ui")]
    public class NoteWithToolbar : Gtk.Box {
        public Quicknote.Note note;
        [GtkChild] public unowned Gtk.TextView textview;
        [GtkChild] public unowned Quicknote.Toolbar toolbar;
        Gtk.TextIter start;
        Gtk.TextIter end;
        Gtk.TextIter cursoriter;

        public NoteWithToolbar (Quicknote.Note n) {
            note = n;

            textview.set_buffer(note.textbuffer);
            note.textbuffer.mark_set.connect (() => {
                check_buttons();
            });
            toolbar.bold.toggled.connect (() => {
                note.apply_tag("bold");
            });
            toolbar.strikethrough.toggled.connect (() => {
                note.apply_tag("strikethrough");
            });
            toolbar.italic.toggled.connect (() => {
                note.apply_tag("italic");
            });
            toolbar.highlight.toggled.connect (() => {
                note.apply_tag("highlight");
            });
            //textbuffer.create_tag("underline", underline: SINGLE);
            //note.load_note("Untitled note");
        }

        public NoteWithToolbar.refnote (ref Quicknote.Note n) {
            note = n;

            textview.set_buffer(note.textbuffer);
            note.textbuffer.mark_set.connect (() => {
                check_buttons();
            });
            toolbar.bold.toggled.connect (() => {
                note.apply_tag("bold");
            });
            toolbar.strikethrough.toggled.connect (() => {
                note.apply_tag("strikethrough");
            });
            toolbar.italic.toggled.connect (() => {
                note.apply_tag("italic");
            });
            toolbar.highlight.toggled.connect (() => {
                note.apply_tag("highlight");
            });
            //textbuffer.create_tag("underline", underline: SINGLE);
            //note.load_note("Untitled note");
        }

        public void check_buttons () {
            bool bold = false;
            bool italic = false;
            bool strikethrough = false;
            bool highlight = false;
            if(note.textbuffer.get_selection_bounds(out start, out end)) {
            } else {
                note.textbuffer.get_iter_at_mark(out cursoriter, note.textbuffer.get_insert());
                var taglist = cursoriter.get_tags();
                taglist.@foreach ((item) => {
                    switch (item.name) {
                        case "bold":
                            toolbar.bold.set_active(true);
                            bold = true;
                            break;
                        case "italic":
                            toolbar.italic.set_active(true);
                            italic = true;
                            break;
                        case "highlight":
                            toolbar.highlight.set_active(true);
                            highlight = true;
                            break;
                        case "strikethrough":
                            toolbar.strikethrough.set_active(true);
                            strikethrough = true;
                            break;
                    }
                });
                if(bold == false) {
                    toolbar.bold.set_active(false);
                }
                if (italic == false) {
                    toolbar.italic.set_active(false);
                }
                if (highlight == false) {
                    toolbar.highlight.set_active(false);
                }
                if (strikethrough == false) {
                    toolbar.strikethrough.set_active(false);
                }
            }
        }
    }
}
