⎕IO←0

∇ result←balanced line
  opens←'({['
  closes←')}]'

  stack←''
  valid←1

  :For char :In line
    :If valid
      :If 0≠⍴opens~⊂char
        stack←stack,⊂char
      :Else
        :If 0≠⍴closes~⊂char
          :If 0=⍴stack
            valid←0
          :Else
            idx←closes⍳char
            :If (⊃⌽stack)≡(⊃opens[idx])
              stack←¯1↓stack
            :Else
              valid←0
            :EndIf
          :EndIf
        :EndIf
      :EndIf
    :EndIf
  :EndFor

  result←valid∧0=⍴stack
∇

input←↓⎕NGET '/dev/stdin' 1
output←{balanced ⍵}¨input
display←output⊃¨'no' 'yes'
{⎕←⍵}¨display
