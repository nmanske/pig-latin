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

int main(string[] args) {
    Gtk.init (ref args);
    var window = new Gtk.Window ();
    window.title = "Pig Latin";
    window.set_border_width (12);
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (350, 250);
    window.destroy.connect (Gtk.main_quit);

    Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

    var input = new Gtk.Entry ();
    input.placeholder_text = "Text to translate...";

    var output = new Gtk.Entry ();
    output.editable = false;

    input.activate.connect(() => {
        output.set_text (translate (input.get_text()));
    });


    box.pack_start (input, false, true, 8);
    box.pack_start (output, false, true, 8);
    window.add (box);
    window.show_all ();

    Gtk.main ();
    return 0;
}

/* Take in a string and spit out Pig Latin */
string translate(string input) {
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
string process_word(string word) {
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
bool word_is_uppercase(string word) {
    if (word == "I") return false;
    int count = 0;
    for (int i = 0; i < word.length; i++)
        if (word_is_capitalized(word[i].to_string()))
            count++;
    if (count == word.length)
        return true;
    return false;
}

/* Check if a word is capitalized */
bool word_is_capitalized(string word) {
    if(/[A-Z]/.match(word[0].to_string()))
        return true;
    return false;
}
