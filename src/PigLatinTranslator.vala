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

    public class PigLatinTranslator : WordTranslator {

        public override string encode_phrase (string phrase) {
            Regex vowels = /[aeiou]/i;
            string result = phrase;
            /* Process words that start with vowel sounds */
            if (vowels.match (result[0:1]))
                result = result + "w";
            /* Process words that start with consonant sounds */
            else {
                /* Check for QU and just put it at the end */
                if (/qu/i.match (result[0:2]))
                    result = result[2:phrase.length]+result[0:2];
                /* Otherwise find the first vowel and start the word there */
                else {
                    int index_of_first_vowel = 1;
                    for (int i = 1; i < result.length; i++) {
                        string first_letter = result[i:i+1];
                        if (vowels.match (first_letter) || /[y]/i.match (first_letter)) {
                            index_of_first_vowel = i;
                            break;
                        }
                    }
                    result = result[index_of_first_vowel:result.length] + result[0:index_of_first_vowel];
                }
            }
            result = result + "ay";
            return result;
        }

    }

}
