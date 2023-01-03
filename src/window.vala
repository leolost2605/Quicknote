/* window.vala
 *
 * Copyright 2022 Leonhard Kargl
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quicknote {
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild] private unowned Gtk.Button opennote;
        [GtkChild] private unowned Gtk.ScrolledWindow gridviewscrolledwindow;
        public Gtk.GridView gridview;
        public List<Quicknote.NoteItem> notes = new List<Quicknote.NoteItem> ();

        
        public Window (Gtk.Application app) {
            Object (application: app);
            
            var css_provider = new Gtk.CssProvider ();
            uint8[] data = (uint8[])".transparentbackground {background: transparent;} gridview child {margin: 10px;}".to_utf8 ();
            css_provider.load_from_data(data);
            Gtk.StyleContext.add_provider_for_display(this.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

            //load_notes_into_flowbox();
            create_gridview_ui ();
            load_notes_from_files ();

            opennote.clicked.connect (() => {
                var note = new Quicknote.Notewindow(app);
                note.present();
            });
        }

        public void create_gridview_ui () {
            var factory = new Gtk.BuilderListItemFactory.from_resource(null, "/io/github/leolost2605/quicknote/note-cell.ui");
            var selection_model = new Gtk.MultiSelection(populate_model());
            gridview = new Gtk.GridView(selection_model, factory) {
                enable_rubberband = true,
                margin_start = 20,
                margin_end = 20,
                margin_top = 20,
                margin_bottom = 20,
            };
            gridview.add_css_class("transparentbackground");
            gridviewscrolledwindow.set_child(gridview);
        }

        /*
        public void load_notes_into_flowbox () {
            flowbox.append(create_flowbox_widget_from_note("test", "second test"));
            flowbox.append(create_flowbox_widget_from_note("test", "second test"));
        }

        public Gtk.Widget create_flowbox_widget_from_note (string title, string content) {
            var clamp = new Adw.Clamp () {
                maximum_size = 50,
                orientation = VERTICAL
            };
            var box = new Gtk.Box(VERTICAL, 0) {
                width_request = 50,
                height_request = 50
            };
            clamp.set_child(box);
            box.append(new Gtk.Label("i am a flowbox child"));
            clamp.add_css_class("activatable");
            return clamp;
        }*/

        public ListStore populate_model () {
            Type type = typeof(Quicknote.NoteItem);
            var model = new ListStore(type);

            load_notes_from_files ();
            notes.@foreach ((item) => {
                model.append(item);
            });

            return model;
        }

        public void load_notes_from_files () {
            File dir = File.new_for_path(Environment.get_user_data_dir () + "/quicknote/notes");

            if(!dir.query_exists()) {
                try {
                    dir.make_directory_with_parents ();
                } catch (Error e) {
                    print(e.message);
                }
            } else {
                try {
                    var enumerator = dir.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS, null);
                    FileInfo info;
                    while ((info = enumerator.next_file()) != null) {
                        print(info.get_name());
                        File file = dir.get_child(info.get_name());
                        notes.append(read_note_from_file(file));
                        print(file.get_path());
                    }
                } catch (Error e) {
                    print(e.message);
                }
            }
        }

        public NoteItem read_note_from_file (File file) {
            var item = new Quicknote.NoteItem (file.get_basename());
            uint8[] content;
            string etag_out;
            try {
                file.load_contents(null, out content, out etag_out);
            } catch (Error e) {
                print(e.message);
                item.content.set_text ("Error: Could not load note");
                return item;
            }
            var parser = new Parser ();
            parser.string_to_textbuffer_with_tags ((string) content, ref item.content);
            return item;
        }
    }
}
