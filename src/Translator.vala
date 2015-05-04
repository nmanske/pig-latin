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

        /* The expression for breaking the input into parts */
        protected Regex phrase_exp;

        /* Main translate method */
        public virtual string translate (string input) {
            return phrase_exp.replace_eval (input, -1, 0, 0, encode_phrase_cb);
        }

        /* For encoding each phrase */
        public abstract string encode_phrase (string phrase);

        /* Any pre-processing on the phrase */
        protected virtual string pre_process_phrase (string phrase) {
            return phrase;
        }

        /* Any post-processing on the phrase */
        protected virtual string post_process_phrase (string new_phrase, string original_phrase) {
            return new_phrase;
        }

        /* The regex callback */
        private bool encode_phrase_cb (MatchInfo match_info, StringBuilder result) {
            string phrase = match_info.fetch (0);
            result.append (post_process_phrase (encode_phrase (pre_process_phrase(phrase)), phrase));
            return false;
        }

    }

}
