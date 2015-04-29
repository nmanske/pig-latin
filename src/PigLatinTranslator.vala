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

        public override string process_word(string word) {
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
    }

}
