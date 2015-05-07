/*

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

namespace PigLatin {

    public static int main (string[] args) {
        Gtk.init (ref args);
        var application = new PigLatinApp ();
        return application.run (args);
    }

    public class PigLatinApp : Granite.Application {

        private static Translator pig_latin_translator = new PigLatinTranslator ();
        private static Translator reverse_translator = new ReverseTranslator ();
        private static Translator binary_translator = new BinaryTranslator ();
        private static Translator current_translator = pig_latin_translator;

        private Gtk.TextView input = new Gtk.TextView ();
        private Gtk.Label output = new Gtk.Label (null);

        construct {
            // Granite automatically makes an "About" section with this stuff
            application_id = "me.alexgleason.piglatin";
            flags = ApplicationFlags.FLAGS_NONE;
            program_name = "Pig Latin";
            app_years = "2015";
            build_version = "0.1.0";
            app_icon = "pig-latin";
            main_url = "https://launchpad.net/pig-latin";
            bug_url = "https://bugs.launchpad.net/pig-latin";
            help_url = "https://answers.launchpad.net/pig-latin";
            // translate_url = "";
            // about_documenters = { null };
            // about_artists = { null };
            about_authors = { "Alex Gleason <alex@alexgleason.me>" };
            about_comments = "An encoder of frivolous jargon.";
            // about_translators = null;
            about_license_type = Gtk.License.GPL_3_0;
        }

        public override void activate () {
            var window = new Gtk.Window ();
            window.title = this.program_name;
            window.set_border_width (0);
            window.set_position (Gtk.WindowPosition.CENTER);
            window.set_default_size (460, 500);
            window.destroy.connect (Gtk.main_quit);
            this.add_window (window);

            // Clipboard
            Gdk.Display display = window.get_display ();
            Gtk.Clipboard clipboard = Gtk.Clipboard.get_for_display (display, Gdk.SELECTION_CLIPBOARD);
            var copy_button = new Gtk.ToolButton.from_stock (Gtk.Stock.COPY);

		    // Combo Box
		    Gtk.ComboBoxText combo_box = new Gtk.ComboBoxText ();
		    combo_box.append ("pig-latin", "Pig Latin");
		    combo_box.append ("reverse", "Reverse");
            combo_box.append ("binary", "Binary");
		    combo_box.active = 0;
		    combo_box.changed.connect (() => {
			    switch (combo_box.get_active_id ()) {
                    case "pig-latin":
                        current_translator = pig_latin_translator;
                        break;
                    case "reverse":
                        current_translator = reverse_translator;
                        break;
                    case "binary":
                        current_translator = binary_translator;
                        break;
                    default:
                        current_translator = pig_latin_translator;
                        break;
                }
                update_buffer();
		    });

            // Headerbar
            var clear_button = new Gtk.ToolButton.from_stock (Gtk.Stock.CLEAR);
            Gtk.HeaderBar headerbar = new Gtk.HeaderBar ();
            headerbar.show_close_button = true;
            headerbar.title = program_name;
            window.set_titlebar (headerbar);
            headerbar.pack_start (combo_box);
            headerbar.pack_end (clear_button);
            headerbar.pack_end (copy_button);

            input.wrap_mode = Gtk.WrapMode.WORD;
            output.wrap_mode = Pango.WrapMode.WORD;
            output.single_line_mode = false;
            output.wrap = true;
            output.selectable = true;
            output.margin = 12;
            input.left_margin = 12;
            input.right_margin = 12;
            input.pixels_above_lines = 10;
            output.get_style_context ().add_class ("h3");

            input.buffer.changed.connect(() => {
                update_buffer ();
            });
            update_buffer (); // Run on start

            clear_button.clicked.connect(() => {
                input.buffer.text = "";
            });

            copy_button.clicked.connect(() => {
                clipboard.set_text (output.get_label(), -1);
            });

            /* Add the text boxes as scrollable panes */
            Gtk.Paned paned = new Gtk.Paned (Gtk.Orientation.VERTICAL);
            Gtk.ScrolledWindow input_scrollbox = new Gtk.ScrolledWindow (null, null);
            Gtk.ScrolledWindow output_scrollbox = new Gtk.ScrolledWindow (null, null);
            input_scrollbox.add (input);
            output_scrollbox.add (output);
            paned.pack1 (input_scrollbox, true, false);
            paned.pack2 (output_scrollbox, true, false);

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.add (paned);
            window.add (scrolled_window);
            window.show_all ();
        }

        private void update_buffer () {
            output.set_label (current_translator.translate (input.buffer.text));
        }
    }
}
