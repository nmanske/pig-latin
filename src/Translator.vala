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

    public abstract class Translator {

        /* Breaks string into words and translates them word-by-word */
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
        public abstract string process_word(string word);

        /* Check if word is uppercase */
        protected bool word_is_uppercase(string word) {
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
        protected bool word_is_capitalized(string word) {
            if(/[A-Z]/.match(word[0].to_string()))
                return true;
            return false;
        }
    }

}
