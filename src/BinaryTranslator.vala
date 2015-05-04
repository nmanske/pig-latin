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

    public class BinaryTranslator : Translator {

        construct {
            /* Matches the whole string */
            this.phrase_exp = /[\s\S]*/;
        }

        public override string encode_phrase (string phrase) {
            string result = "";
            /* Some real magic happens here */
            for (int i = 0; i < 8 * phrase.length; i++) {
                result += ((int) (0 != (phrase[i/8] & 1 << (~i&7)))).to_string();
                if ( (i + 1) % 8 == 0)
                    result += " ";
            }
            return result;
        }

    }

}
