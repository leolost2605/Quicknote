namespace Quicknote {
    public class Notebook : Object {
        public string name { get; set; }
        public string path { get; set; }
        public List<Quicknote.Note> notes;

        public Notebook (string p, string n) {
            path = p;
            name = n;
            notes = new List<Quicknote.Note> ();
        }
    }
}
