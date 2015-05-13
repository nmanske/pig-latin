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

    public abstract class WordTranslator : Translator {

        construct {
            /* This breaks the input up into words */
            this.phrase_exp = /(\b|(?:_*)?)([a-z']+)((?:_*)?|\b)/i;
        }

        /* Lowercases a capitalized letter since it will be moved */
        protected override string pre_process_phrase (string phrase) {
            string result = phrase;
            if (word_get_case (phrase) == "capitalized")
                result = result[0:1].down () + result[1:result.length];
            return result;
        }

        /* Fixes the case post processing based on the case of the original word */
        protected override string post_process_phrase (string new_phrase, string original_phrase) {
            string result = new_phrase;
            if (word_is_uppercase (original_phrase))
                result = result.up ();
            else if (word_is_capitalized (original_phrase))
                result = result[0:1].up () + result[1:result.length];
            return result;
        }

        /* Get the word's case */
        private string word_get_case (string word) {
            string result = word;
            if (word_is_uppercase (word))
                result = "uppercase";
            else if (word_is_capitalized (word))
                result = "capitalized";
            else
                result = "";
            return result;
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

        /* The regex callback */
        protected override bool encode_phrase_cb (MatchInfo match_info, StringBuilder result) {
            string phrase = match_info.fetch (2);
            result.append (match_info.fetch (1) + post_process_phrase (encode_phrase (pre_process_phrase(phrase)), phrase) + match_info.fetch (3));
            return false;
        }

    }

}
