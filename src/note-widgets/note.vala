namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-widgets/note.ui")]
    public class Note : Gtk.Box {
        [GtkChild] public unowned Gtk.TextView textview;
        [GtkChild] public unowned Quicknote.Toolbar toolbar;
        Gtk.TextBuffer textbuffer;
        Gtk.TextIter start;
        Gtk.TextIter end;
        Gtk.TextIter cursoriter;

        public Note () {
            var css_provider = new Gtk.CssProvider();

            uint8[] data = (uint8[])".transparenttextview {background: transparent;}".to_utf8 ();
            css_provider.load_from_data(data);
            Gtk.StyleContext.add_provider_for_display(this.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

            textbuffer = textview.get_buffer();
            textbuffer.mark_set.connect (() => {
                check_buttons();
            });
            textbuffer.create_tag("bold", weight: 700);
            toolbar.bold.toggled.connect (() => {
                apply_tag("bold");
            });
            textbuffer.create_tag("strikethrough", strikethrough: true);
            toolbar.strikethrough.toggled.connect (() => {
                apply_tag("strikethrough");
            });
            textbuffer.create_tag("italic", style: Pango.Style.ITALIC);
            toolbar.italic.toggled.connect (() => {
                apply_tag("italic");
            });
            textbuffer.create_tag("highlight", background: "yellow");
            toolbar.highlight.toggled.connect (() => {
                apply_tag("highlight");
            });
            //textbuffer.create_tag("underline", underline: SINGLE);
            load_note("Untitled note");
        }

        public void apply_tag (string tagname) {
            textbuffer.get_selection_bounds(out start, out end);

            bool tagisset = false;
            var taglist = start.get_tags();
            taglist.@foreach ((item) => {
                if(item.name == tagname) {
                    textbuffer.remove_tag_by_name(tagname, start, end);
                    tagisset = true;
                    return;
                }
            });
            if(tagisset == false) {
                textbuffer.apply_tag_by_name (tagname, start ,end);
            }
        }

        public void check_buttons () {
            bool bold = false;
            bool italic = false;
            bool strikethrough = false;
            bool highlight = false;
            if(textbuffer.get_selection_bounds(out start, out end)) {
            } else {
                textbuffer.get_iter_at_mark(out cursoriter, textbuffer.get_insert());
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

        public void save_note (string title) {
            var parser = new Parser ();
            string result = parser.textbuffer_with_tags_to_string (textbuffer);
            write_data(title, result);
        }

        public void load_note (string title) {
            var parser = new Parser ();
            parser.string_to_textbuffer_with_tags (read_data (title), ref textbuffer);
        }

        public void write_data (string filename, string text) {
            var dir = File.new_for_path (Environment.get_user_data_dir () + "/quicknote/notes");
            if(!dir.query_exists ()) {
                try {
                    dir.make_directory_with_parents();
                } catch (Error e) {
                    print(e.message);
                }
            }

            var file = File.new_for_path(Environment.get_user_data_dir () + @"/quicknote/notes/$filename");

            uint8[] write_text = (uint8[]) text.to_utf8 ();

            try {
                file.replace_contents (write_text, null, false, FileCreateFlags.NONE, null, null);
            } catch (Error e) {
                print (e.message);
            }
        }

        public string read_data (string title) {
            var dir = File.new_for_path (Environment.get_user_data_dir () + "/quicknote/notes");
            if(!dir.query_exists ()) {
                try {
                    dir.make_directory_with_parents();
                } catch (Error e) {
                    print(e.message);
                }
            }

            var file = File.new_for_path(Environment.get_user_data_dir () + @"/quicknote/notes/$title");

            if(file.query_exists()) {
                uint8[] content;
                string etag_out;
                try {
                    file.load_contents(null, out content, out etag_out);
                    return (string) content;
                } catch (Error e) {
                    print(e.message);
                    return "";
                }
            } else {
                print("note doesnt exist");
                return "";
            }
        }
    }
}
