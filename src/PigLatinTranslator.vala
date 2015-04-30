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

    public class PigLatinTranslator : Translator {

        public override string encode_word (string word) {
            unichar[] vowels = { 'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U' };
            string result = word;
            /* Process words that start with vowel sounds */
            if (result[0] in vowels)
                result = result + "w";
            /* Process words that start with consonant sounds */
            else {
                /* Check for QU and just put it at the end */
                if (result.up ()[0] == 'Q' && result.up ()[1] == 'U')
                    result = result[2:word.length]+result[0:2];
                /* Otherwise find the first vowel and start the word there */
                else {
                    int index_of_first_vowel = 1;
                    for (int i = 1; i < result.length; i++) {
                        if (result[i] in vowels || result.up ()[i] == 'Y') {
                            index_of_first_vowel = i;
                            break;
                        }
                    }
                    result = result[index_of_first_vowel:result.length] + result[0:index_of_first_vowel];
                }
            }
            result = result+"ay";
            return result;
        }

        public override string decode_word (string word) {
            string result = word;
            result = result[0:result.length - 2];
            return result;
        }
    }

}
