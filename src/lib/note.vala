namespace Quicknote {
    public class Note : Object {
        public Gtk.TextBuffer textbuffer;
        public Gtk.TextBuffer buffer {get; set;}
        public string textforpreview { get; set; }
        public string title { get; set; }
        public string titleforpreview {get; set; }
        public string ogtitle { get; set; }
        public DateTime lastedited {get; set;}
        public string lasteditedstr {get; set; }
        Gtk.TextIter start;
        Gtk.TextIter end;

        public Note () {
            //buffer for preview
            buffer = new Gtk.TextBuffer (null);

            textbuffer = new Gtk.TextBuffer (null);
            assert(textbuffer != null);
            textbuffer.create_tag("bold", weight: 700);
            textbuffer.create_tag("strikethrough", strikethrough: true);
            textbuffer.create_tag("italic", style: Pango.Style.ITALIC);
            textbuffer.create_tag("highlight", background: "yellow");
            //textbuffer.create_tag("underline", underline: SINGLE);
        }

        // public Note.load_from_file_string (string file) {
        //     ogtitle = file;
            //buffer for preview
        //     buffer = new Gtk.TextBuffer (null);

        //     textbuffer = new Gtk.TextBuffer (null);
        //     assert(textbuffer != null);
        //     textbuffer.create_tag("bold", weight: 700);
        //     textbuffer.create_tag("strikethrough", strikethrough: true);
        //     textbuffer.create_tag("italic", style: Pango.Style.ITALIC);
        //     textbuffer.create_tag("highlight", background: "yellow");

        //     load_note(string_to_file(file));
        // }

        public Note.load_from_file_path_string (string fullpath) {
            var tempfile = File.new_for_path(fullpath);
            ogtitle = tempfile.get_basename();
            //buffer for preview
            buffer = new Gtk.TextBuffer (null);

            textbuffer = new Gtk.TextBuffer (null);
            assert(textbuffer != null);
            textbuffer.create_tag("bold", weight: 700);
            textbuffer.create_tag("strikethrough", strikethrough: true);
            textbuffer.create_tag("italic", style: Pango.Style.ITALIC);
            textbuffer.create_tag("highlight", background: "yellow");

            load_note(tempfile);
        }

        public Note.load_from_file(File file) {
            ogtitle = file.get_basename();
            //buffer for preview
            buffer = new Gtk.TextBuffer (null);

            textbuffer = new Gtk.TextBuffer (null);
            assert(textbuffer != null);
            textbuffer.create_tag("bold", weight: 700);
            textbuffer.create_tag("strikethrough", strikethrough: true);
            textbuffer.create_tag("italic", style: Pango.Style.ITALIC);
            textbuffer.create_tag("highlight", background: "yellow");

            load_note(file);
        }

        public File string_to_file (string str) {
            var dir = File.new_for_path (Environment.get_user_data_dir () + "/quicknote/notes");
            if(!dir.query_exists ()) {
                try {
                    dir.make_directory_with_parents();
                } catch (Error e) {
                    print(e.message);
                }
            }

            var file = File.new_for_path(Environment.get_user_data_dir () + @"/quicknote/notes/$str");
            return file;
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

        public void save_note (string path, string? t) {
            if(t != null) {
                title = t;
            }
            if(ogtitle != null && ogtitle != title) {
                var file = File.new_for_path (path + @"/$ogtitle");
                try {
                    file.trash();
                } catch (Error e) {
                    print(e.message);
                }
            }
            lastedited = new DateTime.now_utc();

            var parser = new Parser ();
            string result = parser.textbuffer_with_tags_to_string (textbuffer);
            write_data(path, title, result);

            //reload textforpreview and title
            textbuffer.get_bounds(out start, out end);
            textforpreview = textbuffer.get_text(start, end, false);
            if(textforpreview.contains("\n")) {
                textforpreview = textforpreview.slice(0, textforpreview.index_of("\n", 0));
            }
            if(textforpreview.length > 50) {
                textforpreview = textforpreview[0:50];
            }
        }

        public void load_note (File file) {
            title = file.get_basename();
            titleforpreview = title;
            if(titleforpreview.length > 20) {
                titleforpreview = titleforpreview.slice(0, 20) + "...";
            }
            string contentstr = "";

            if(file.query_exists()) {
                uint8[] content;
                string etag_out;
                try {
                    file.load_contents(null, out content, out etag_out);
                    contentstr = (string) content;
                } catch (Error e) {
                    print(e.message);
                    return;
                }
                try {
                    var info = file.query_info("*", FileQueryInfoFlags.NONE, null);
                    lastedited = info.get_modification_date_time ();
                    lasteditedstr = lastedited.format("%d/%m/%Y - %H:%M:%S");
                } catch (Error e) {
                    print(e.message);
                }
            }

            var parser = new Parser ();
            parser.string_to_textbuffer_with_tags (contentstr, ref textbuffer);
            buffer = textbuffer;

            textbuffer.get_bounds(out start, out end);
            textforpreview = textbuffer.get_text(start, end, false);
            if(textforpreview.contains("\n")) {
                textforpreview = textforpreview.slice(0, textforpreview.index_of("\n", 0));
            }
            if(textforpreview.length > 50) {
                textforpreview = textforpreview[0:50];
            }
        }

        public void write_data (string path, string filename, string text) {
            var dir = File.new_for_path (path);
            if(!dir.query_exists ()) {
                try {
                    dir.make_directory_with_parents();
                } catch (Error e) {
                    print(e.message);
                }
            }

            var file = File.new_for_path(path + @"/$filename");

            uint8[] write_text = (uint8[]) text.to_utf8 ();

            try {
                file.replace_contents (write_text, null, false, FileCreateFlags.NONE, null, null);
            } catch (Error e) {
                print (e.message);
            }
        }
    }
}
