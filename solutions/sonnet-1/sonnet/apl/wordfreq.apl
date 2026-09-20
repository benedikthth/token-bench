⎕IO←0

⍝ Read all input lines, join with spaces so words don't merge across lines
lines←⊃⎕NGET'/dev/stdin' 1
text←1↓∊' ',¨lines

⍝ Lowercase everything
text←⎕C text

⍝ Extract maximal runs of ASCII letters
Lower←'abcdefghijklmnopqrstuvwxyz'
mask←text∊Lower
words←mask⊆text

:If 0=≢words
    ⍝ no words at all: produce no output
:Else
    ⍝ Count frequency of each distinct word
    keys←∪words
    cnts←{+/(keys[⍵])≡¨words}¨⍳≢keys

    ⍝ Stable sort: first by word ascending, then by count descending
    idx←⍋keys
    keys←keys[idx] ⋄ cnts←cnts[idx]
    idx←⍒cnts
    keys←keys[idx] ⋄ cnts←cnts[idx]

    out←{(⊃keys[⍵]),' ',⍕cnts[⍵]}¨⍳≢keys
    ⎕←∊out,¨⊂⎕UCS 10
:EndIf
