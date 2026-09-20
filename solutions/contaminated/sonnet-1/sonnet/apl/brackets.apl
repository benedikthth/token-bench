⎕IO←0

∇ result←Balanced line
  opens←'([{'
  closes←')]}'
  stack←''
  ok←1
  :For c :In line
    :If ok
      :If c∊opens
        stack←stack,c
      :ElseIf c∊closes
        :If 0=≢stack
          ok←0
        :ElseIf (⊃¯1↑stack)≡opens[closes⍳c]
          stack←¯1↓stack
        :Else
          ok←0
        :EndIf
      :EndIf
    :EndIf
  :EndFor
  result←ok∧0=≢stack
∇

lines←⊃⎕NGET '/dev/stdin' 1
lines←{(⍵≠⎕UCS 13)/⍵}¨lines        ⍝ strip stray CR
results←Balanced¨lines
out←('no' 'yes')[results]
⎕←∊out,¨⊂⎕UCS 10
