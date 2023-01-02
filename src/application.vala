/* application.vala
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
    public class Application : Adw.Application {
        bool noteonly = false;

        public Application () {
            Object (application_id: "io.github.leolost2605.quicknote", flags: ApplicationFlags.FLAGS_NONE);

            var options = new OptionEntry[1];
            options[0] = {"note-only", '\0', OptionFlags.NONE, OptionArg.NONE, ref noteonly, "Launches only a note", null};
            this.add_main_option_entries(options);
        }

        construct {
            ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "preferences", this.on_preferences_action },
                { "quit", this.quit }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null && noteonly) {
                win = new Quicknote.Notewindow (this);
            } else if (win == null) {
                win = new Quicknote.Window (this);
            }
            win.present ();
        }



        private void on_about_action () {
            string[] developers = { "Leonhard Kargl" };
            var about = new Adw.AboutWindow () {
                transient_for = this.active_window,
                application_name = "quicknote",
                application_icon = "io.github.leolost2605.quicknote",
                developer_name = "Leonhard Kargl",
                version = "0.1.0",
                developers = developers,
                copyright = "© 2022 Leonhard Kargl",
            };

            about.present ();
        }

        private void on_preferences_action () {
            message ("app.preferences action activated");
        }
    }
}
