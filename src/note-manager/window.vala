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
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/note-manager/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild] private unowned Adw.Leaflet leaflet;
        [GtkChild] private unowned Gtk.Box mainviewbox;
        [GtkChild] private unowned Gtk.Button opennote;
        [GtkChild] private unowned Gtk.ToggleButton searchbutton;
        [GtkChild] private unowned Gtk.SearchBar searchbar;
        [GtkChild] private unowned Gtk.Stack notebookstack;
        [GtkChild] private unowned Gtk.ListView notebookchooser;
        [GtkChild] private unowned Gtk.Button newbutton;
        public List<Quicknote.Notebook> notebooks = new List<Quicknote.Notebook> ();


        public Window (Gtk.Application app) {
            Object (application: app);

            var css_provider = new Gtk.CssProvider ();
            uint8[] data = (uint8[])"@define-color custom_accent mix(white, #ff0000, 0.6); .transparentbackground {background: transparent;} gridview child {margin: 20px;} listview row {margin-bottom: 3px; border-radius: 10px;} .customborder {border-radius: 10px 10px; border-width: 4px; border-color: #d6a142;} .custom-bg-for-note-view {border-radius: 10px; background-color: @view_bg_color;} .smallfontsize {font-size: small;} .notebookchooser-cell {border-radius: 10px;} .filledbackground {background-color: @view_bg_color;}".to_utf8 ();
            css_provider.load_from_data(data);
            Gtk.StyleContext.add_provider_for_display(this.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

            load_notebooks ();
            load_notes_from_notebooks();
            notebooks.@foreach((notebookitem) => {
                var tempnotebookpage = new NotebookPage (notebookitem);
                tempnotebookpage.note_opened.connect((note) => {
                    var tempnoteviewer = new Quicknote.NoteViewer(note);
                    leaflet.append(tempnoteviewer);
                    leaflet.set_visible_child(tempnoteviewer);
                    tempnoteviewer.back_clicked.connect((editednote) => {
                        tempnotebookpage.close_note(editednote);
                        leaflet.set_visible_child(mainviewbox);
                    });
                });
                notebookstack.add_named(tempnotebookpage, notebookitem.name);
                notebookstack.set_visible_child_name(notebookitem.name);
            });

            populate_notebookchooser();

            opennote.clicked.connect (() => {
                var note = new Quicknote.Notewindow(app);
                note.present();
            });

            newbutton.clicked.connect(() => {

            });

            bool current = false;
            searchbutton.toggled.connect (() => {
                current = !current;
                searchbar.set_search_mode(current);
            });
        }

        public void load_notebooks () {
            File dir = File.new_for_path(Environment.get_user_data_dir () + "/quicknote/notes");

            if(!dir.query_exists()) {
                try {
                    dir.make_directory_with_parents ();
                } catch (Error e) {
                    print(e.message);
                }
            } else {
                try {
                    var enumerator = dir.enumerate_children ("*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS, null);
                    FileInfo info;
                    while ((info = enumerator.next_file()) != null) {
                        if(info.get_file_type() == FileType.DIRECTORY) {
                            string path = dir.resolve_relative_path(info.get_name()).get_path();
                            notebooks.append(new Quicknote.Notebook (path, info.get_name()));
                        }
                    }
                } catch (Error e) {
                    print(e.message);
                }
            }
        }

        public void load_notes_from_notebooks () {
            notebooks.@foreach((item) => {
                File dir = File.new_for_path(item.path);

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
                            string filename = info.get_name();
                            string fullpath = item.path + "/" + filename;
                            item.notes.append(new Quicknote.Note.load_from_file_path_string (fullpath));
                        }
                    } catch (Error e) {
                        print(e.message);
                    }
                }
            });
        }

        public void populate_notebookchooser () {
            var factory = new Gtk.BuilderListItemFactory.from_resource (null, "/io/github/leolost2605/quicknote/note-manager/notebookchooser-cell.ui");
            notebookchooser.set_factory(factory);
            var model = new ListStore (typeof (Quicknote.Notebook));
            notebooks.@foreach ((item) => {
                model.append(item);
            });
            var selection_model = new Gtk.SingleSelection(model) {
                autoselect = true,
                can_unselect = false
            };
            notebookchooser.set_model(selection_model);

            selection_model.selection_changed.connect((pos, items) => {
                var tempitem = (Quicknote.Notebook) selection_model.get_selected_item();
                notebookstack.set_visible_child_name(tempitem.name);
            });
        }
    }
}
