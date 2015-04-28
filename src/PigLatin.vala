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
            window.set_default_size (460, 430);
            window.destroy.connect (Gtk.main_quit);
            this.add_window (window);

            // Headerbar
            Gtk.Menu menu = new Gtk.Menu ();
            var appmenu = this.create_appmenu (menu);
            Gtk.HeaderBar headerbar = new Gtk.HeaderBar ();
            headerbar.show_close_button = true;
            headerbar.title = program_name;
            window.set_titlebar (headerbar);
            headerbar.pack_end (appmenu);

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow (null, null);
            Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var input = new Gtk.TextView ();
            var output = new Gtk.TextView ();
            input.wrap_mode = Gtk.WrapMode.WORD;
            output.wrap_mode = Gtk.WrapMode.WORD;
            output.editable = false;
            output.margin = 12;

            input.buffer.changed.connect(() => {
                output.buffer.text = translate (input.buffer.text);
            });

            box.pack_start (input, true, true, 0);
            box.pack_start (output, true, true, 0);
            scrolled_window.add (box);
            window.add (scrolled_window);
            window.show_all ();
        }

        /* Take in a string and spit out Pig Latin */
        public string translate(string input) {
            string word = "";
            string output = "";
            for (int i = 0; i <= input.length; i++) {
                if (/[a-zA-Z]/.match(input[i].to_string())) {
                    word += input[i].to_string();
                } else {
                    if (word.length > 0) {
                        output += process_word(word);
                        word = "";
                    }
                    output += input[i].to_string();
                }
            }
            return output;
        }

        /* Process a single word */
        public string process_word(string word) {
            unichar[] vowels = {'a','e','i','o','u','A','E','I','O','U'};
            string result = "";
            /* Process words that start with vowel sounds */
            if (word[0] in vowels)
                result = word+"w";
            /* Process words that start with consonant sounds */
            else {
                /* Check for QU and just put it at the end */
                if (word.up()[0] == 'Q' && word.up()[1] == 'U')
                    result = word[2:word.length]+"qu";
                /* Otherwise find the first vowel and start the word there */
                else {
                    int index_of_first_vowel = 1;
                    for (int i = 0; i < word.length; i++) {
                        if (word[i] in vowels) {
                            index_of_first_vowel = i;
                            break;
                        }
                    }
                    result = word[index_of_first_vowel:word.length]+word[0:index_of_first_vowel];
                }
            }
            result = result+"ay";
            result = result.down();
            if (word_is_uppercase(word))
                result = result.up();
            else if (word_is_capitalized(word))
                result = result[0].to_string().up()+result[1:result.length];
            return result;
        }

        /* Check if word is uppercase */
        public bool word_is_uppercase(string word) {
            if (word == "I") return false;

            // TODO: use a regex so this is less bad. Not sure why ^[A-Z]$ doesn't work.
            int count = 0;
            for (int i = 0; i < word.length; i++)
                if (word_is_capitalized(word[i].to_string()))
                    count++;
            if (count == word.length)
                return true;
            return false;
        }

        /* Check if a word is capitalized */
        public bool word_is_capitalized(string word) {
            if(/[A-Z]/.match(word[0].to_string()))
                return true;
            return false;
        }
    }
}
