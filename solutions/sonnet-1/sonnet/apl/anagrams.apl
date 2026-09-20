⎕IO←0
lines←⊃⎕NGET '/dev/stdin' 1
lines←{(⍵≠⎕UCS 13)/⍵}¨lines        ⍝ strip any stray CR
lines←(0<≢¨lines)/lines            ⍝ drop empty lines
:If 0<≢lines
    keys←{⍵[⍋⍵]}¨lines             ⍝ sorted-letters key per word
    ukeys←∪keys
    groups←{((⊂⍵)≡¨keys)/lines}¨ukeys ⍝ words per anagram group
    groups←{⍵[⍋⍵]}¨groups          ⍝ sort words inside each group
    groups←groups[⍋⊃¨groups]       ⍝ sort groups by first word
    lines←{{⍺,' ',⍵}/⍵}¨groups     ⍝ join each group with spaces
    out←∊{⍵,⎕UCS 10}¨lines
    ⎕←out
:EndIf
