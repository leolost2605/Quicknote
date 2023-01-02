public class Parser {

    //type: maybe make a enum?
    //buffer: maybe value?
    public Parser () {

    }

    public string textbuffer_with_tags_to_string (Gtk.TextBuffer buffer) {
        string result = "";
        Gtk.TextIter start;
        Gtk.TextIter end;
        buffer.get_bounds(out start, out end);
        while(start.compare(end) < 0) {
            if(start.ends_line()) {
                result += "/nl/";
                start.forward_char();
            } else {
                var taglist = start.get_tags();
                taglist.@foreach ((item) => {
                    result += item.name + "/>/";
                });
                result += start.get_char().to_string();
                start.forward_char();
                if(start.compare(end) < 0 && start.ends_line() != true) {
                    result += "/#/";
                }
            }
        }
        return result;
    }
    public void string_to_textbuffer_with_tags (string str, ref Gtk.TextBuffer buffer) {
        Gtk.TextIter iter;
        Gtk.TextIter enditer;

        assert(buffer != null);

        buffer.get_end_iter(out iter);

        Regex regex_for_line;
        Regex regex_for_char;
        Regex regex_for_tag;
        try {
            regex_for_line = new Regex ("/nl/");
            regex_for_char = new Regex ("/#/");
            regex_for_tag = new Regex ("/>/");
        } catch (Error e) {
            print(e.message);
            return;
        }

        string[] lines = regex_for_line.split(str);

        for(int z = 0; z < lines.length; z++) {
            string[] chars_with_tags = regex_for_char.split(lines[z]);

            for(int i = 0; i < chars_with_tags.length; i++) {
                string[] tags = regex_for_tag.split(chars_with_tags[i]);
                buffer.insert(ref iter, tags[tags.length - 1], -1);
                iter.backward_char();
                buffer.get_end_iter(out enditer);
                for(int j = 0; j < tags.length - 1; j++) {
                   buffer.apply_tag_by_name(tags[j], iter, enditer);
                }
                buffer.get_end_iter(out iter);
            }
            buffer.insert(ref iter, "\n", -1);

        }
    }
}

