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
    [GtkTemplate (ui = "/io/github/leolost2605/quicknote/ui/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild]
        private unowned Gtk.Label label;
        [GtkChild]
        private unowned Gtk.Button opennote;

        
        public Window (Gtk.Application app) {
            Object (application: app);
            
            opennote.clicked.connect (() => {
                var note = new Quicknote.Notewindow(app);
                note.present();
            });
        }
    }
}