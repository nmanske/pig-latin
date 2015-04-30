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

        construct {
            // Granite automatically makes an "About" section with this stuff
            application_id = "me.alexgleason.piglatin";
            flags = ApplicationFlags.FLAGS_NONE;
            program_name = "Pig Latin Translator";
            app_years = "2015";
            build_version = "0.0.1";
            app_icon = "";
            main_url = "https://github.com/alexgleason/pig-latin/";
            bug_url = "https://github.com/alexgleason/pig-latin/issues";
            help_url = "https://github.com/alexgleason/pig-latin/";
            translate_url = "https://github.com/alexgleason/pig-latin/";
            about_documenters = { null };
            about_artists = { null };
            about_authors = { "Alex Gleason <alex@alexgleason.me>" };
            about_comments = "A pig latin translator. 100% Vegan.";
            about_translators = null;
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

            // Headerbar
            var clear_button = new Gtk.ToolButton.from_stock (Gtk.Stock.CLEAR);
            Gtk.HeaderBar headerbar = new Gtk.HeaderBar ();
            headerbar.show_close_button = true;
            headerbar.title = program_name;
            window.set_titlebar (headerbar);
            headerbar.pack_end (clear_button);
            headerbar.pack_end (copy_button);

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow (null, null);
            Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var input = new Gtk.TextView ();
            var output = new Gtk.TextView ();
            input.wrap_mode = Gtk.WrapMode.WORD;
            output.wrap_mode = Gtk.WrapMode.WORD;
            output.editable = false;
            input.margin = 12;
            output.left_margin = 12;
            output.right_margin = 12;
            output.pixels_above_lines = 10;
            input.left_margin = 12;
            input.right_margin = 12;
            input.pixels_above_lines = 10;
            output.get_style_context().add_class("h3");
            output.cursor_visible = false;

            input.buffer.changed.connect(() => {
                output.buffer.text = pig_latin_translator.translate (input.buffer.text)+"\n";
                //output.buffer.text = reverse_translator.translate (input.buffer.text)+"\n";
            });
            output.buffer.text = "\n";

            clear_button.clicked.connect(() => {
                input.buffer.text = "";
            });

            copy_button.clicked.connect(() => {
                clipboard.set_text (output.buffer.text, -1);
            });

            box.pack_start (input, true, true, 0);
            box.pack_start (output, true, true, 0);
            scrolled_window.add (box);
            window.add (scrolled_window);
            window.show_all ();
        }
    }
}
