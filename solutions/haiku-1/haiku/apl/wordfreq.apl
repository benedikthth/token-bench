⎕IO ← 1

⍝ Read all input from stdin
input ← ⊃ ⎕SH 'cat'

⍝ Get character codes for classification
codes ← ⎕AV ⍳ input

⍝ Create mask for letter positions (A-Z: 65-90, a-z: 97-122)
is_upper ← (codes ≥ 65) ⌊ (codes ≤ 90)
is_lower ← (codes ≥ 97) ⌊ (codes ≤ 122)
is_letter ← is_upper ⌈ is_lower

⍝ Extract words: partition by letter mask
words_raw ← is_letter ⊂ input

⍝ Remove empty strings
non_empty ← (≢¨ words_raw) ≠ 0
words_raw ← words_raw[non_empty]

⍝ Convert to lowercase using character codes
Convert_Lower ← {
    codes ← ⎕AV ⍳ ⍵
    is_upper ← (codes ≥ 65) ⌊ (codes ≤ 90)
    codes ← codes + (32 × is_upper)
    ⎕AV[codes]
}
words ← Convert_Lower ¨ words_raw

⍝ Get unique words and count occurrences
unique_words ← ∪ words
word_counts ← {+/words = ⊂⍵} ¨ unique_words

⍝ Sort by word (ascending) for stable secondary sort
sort_by_word ← ⍋ unique_words
sorted_words ← unique_words[sort_by_word]
sorted_counts ← word_counts[sort_by_word]

⍝ Sort by count (descending)
sort_by_count ← ⍒ sorted_counts
final_words ← sorted_words[sort_by_count]
final_counts ← sorted_counts[sort_by_count]

⍝ Build output - output each line
{⎕← ⍵} ¨ (final_words , ' ' , ⍕¨ final_counts)
