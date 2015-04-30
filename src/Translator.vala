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

    public abstract class Translator : GLib.Object {

        protected Regex words = /\b[a-zA-Z']+\b/;

        /* Breaks string into words and encodes them word-by-word */
        public virtual string translate (string input, bool decode = false) {
            RegexEvalCallback eval = encode_word_cb;
            if (decode)
                eval = decode_word_cb;
            return words.replace_eval (input, -1, 0, 0, eval);
        }

        public abstract string encode_word (string word);
        public abstract string decode_word (string word);

        protected virtual string pre_process_word (string word) {
            string result = word;
            if (word_get_case (word) == "capitalized")
                result = result[0:1].down () + result[1:result.length];
            return result;
        }

        /* Fixes the case post processing based on the case of the original word */
        protected virtual string post_process_word (string new_word, string original_word) {
            string result = new_word;
            if (word_is_uppercase (original_word))
                result = result.up ();
            else if (word_is_capitalized (original_word))
                result = result[0:1].up () + result[1:result.length];
            return result;
        }

        /* Get the word's case */
        protected string word_get_case (string word) {
            string result = word;
            if (word_is_uppercase (word))
                result = "uppercase";
            else if (word_is_capitalized (word))
                result = "capitalized";
            else
                result = "";
            return result;
        }

        private bool encode_word_cb (MatchInfo match_info, StringBuilder result) {
            string word = match_info.fetch (0);
            result.append (post_process_word (encode_word (pre_process_word(word)), word));
            return false;
        }

        private bool decode_word_cb (MatchInfo match_info, StringBuilder result) {
            string word = match_info.fetch (0);
            result.append (post_process_word (decode_word (pre_process_word(word)), word));
            return false;
        }

        /* Check if word is uppercase */
        private bool word_is_uppercase (string word) {
            if (word == "I") return false;
            if (/^[^a-z]+$/.match (word))
                return true;
            return false;
        }

        /* Check if a word is capitalized */
        private bool word_is_capitalized (string word) {
            if (/[A-Z]/.match (word[0:1]))
                return true;
            return false;
        }
    }

}
