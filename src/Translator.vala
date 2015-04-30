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
        public string translate (string input) {
            string word = "";
            string output = "";
            for (int i = 0; i <= input.length; i++) {
                /* Load alphanumeric characters into the word buffer */
                if (is_alphanumeric (input[i]))
                    word += input[i].to_string();
                /* (this special case deals with contractions) */
                else if (input[i] == '\'' && is_alphanumeric (input[i-1]) && is_alphanumeric (input[i+1]))
                    word += input[i].to_string();
                /* ...until a symbol is hit, then process the word */
                else {
                    if (word.length > 0) {
                        output += fix_case (process_word (fix_case_pre (word)), word);
                        word = "";
                    }
                    output += input[i].to_string();
                }
            }
            return output;
        }

        /* Process a single word */
        public abstract string process_word (string word);

        /* Modifies the case of a word before processing.
           Keep the result of this in a separate variable from the original word, then you can compare them. */
        protected string fix_case_pre (string word) {
            string result = word;
            if (word_is_capitalized(word) && !word_is_uppercase (word))
                /* Lowercase the first letter of a capitalized word since the letter will probably
                   be moved. The word gets uncapitalized in fix_case. Implementing a Word class
                   would probably make this better because you could store that its capitalized
                   directly inside it. */
                result = result[0].to_string().down() + result[1:result.length];
            return result;
        }

        /* Fixes the case post processing based on the case of the original word */
        protected string fix_case (string new_word, string original_word) {
            string result = new_word;
            if (word_is_uppercase (original_word))
                result = result.up();
            else if (word_is_capitalized (original_word))
                result = result[0].to_string().up() + result[1:result.length];
            return result;
        }

        /* Check if word is uppercase */
        protected bool word_is_uppercase (string word) {
            if (word == "I") return false;
            if (/^[^a-z]{0,}$/.match (word))
                return true;
            return false;
        }

        /* Check if a word is capitalized */
        protected bool word_is_capitalized (string word) {
            if (/[A-Z]/.match (word[0].to_string()))
                return true;
            return false;
        }

        /* Check if character is a letter */
        protected bool is_alphanumeric (unichar letter) {
            return /[a-zA-Z]/.match (letter.to_string());
        }
    }

}
