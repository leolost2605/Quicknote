namespace Quicknote {
    public class NoteItem : Object {
        public string title { get; set; }
        public Gtk.TextBuffer content;
        public NoteItem (string t) {
            title = t;
        }
    }
}
