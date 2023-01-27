namespace Quicknote {
    [GtkTemplate (ui="/io/github/leolost2605/quicknote/note-window/note-window.ui")]
    public class Notewindow : Adw.ApplicationWindow {
        [GtkChild] public unowned Gtk.Box viewbox;
        [GtkChild] public unowned Gtk.Entry titleentry;
        Quicknote.NoteWithToolbar notewithtoolbar;

        public Notewindow (Gtk.Application app) {
            Object (
                application: app
            );

            var css_provider = new Gtk.CssProvider();
            uint8[] data = (uint8[])".transparenttextview {background: transparent;}".to_utf8 ();
            css_provider.load_from_data(data);
            Gtk.StyleContext.add_provider_for_display(this.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

            var titlebuffer = titleentry.get_buffer();
            titlebuffer.set_text((uint8[])"Untitled note".to_utf8());
            titleentry.set_alignment(0.5f);
            notewithtoolbar = new Quicknote.NoteWithToolbar (new Quicknote.Note());
            notewithtoolbar.textview.add_css_class("transparenttextview");
            viewbox.append(notewithtoolbar);

            this.close_request.connect (() => {
                notewithtoolbar.note.save_note(Environment.get_user_data_dir () + "/quicknote/notes/Default", titleentry.get_text());
                return false;
            });
        }


    }
}
