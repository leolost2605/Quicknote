namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-manager/notebook-page/notebook-page.ui")]
    public class NotebookPage : Gtk.Box {
        [GtkChild] private unowned Gtk.ListBox firstsectionlistbox;
        public Quicknote.Notebook notebook;

        public NotebookPage (Quicknote.Notebook n) {
            notebook = n;
            populate_listbox ();
        }

        public signal void note_opened (Quicknote.Note n);

        public void populate_listbox () {
            assert(firstsectionlistbox != null);
            notebook.notes.@foreach((note) => {
                var temprow = new Adw.ActionRow() {
                    title = note.titleforpreview,
                    name = note.title,
                    subtitle = note.textforpreview
                };
                firstsectionlistbox.append(temprow);
            });
            firstsectionlistbox.row_selected.connect((row) => {
                notebook.notes.@foreach ((item)=> {
                    if(item.title == row.name) {
                        note_opened (item);
                    }
                });
            });
        }

        public void close_note (Quicknote.Note editednote) {
            editednote.save_note (notebook.path, editednote.title);
        }
    }
}
