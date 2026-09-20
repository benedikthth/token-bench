⎕IO←0

∇r←Check s
  ⍝ Returns 1 if brackets in s are balanced/nested, 0 otherwise.
  open←'([{'
  close←')]}'
  stack←⍬
  r←1
  :For c :In s
      :If c∊open
          stack←stack,c
      :ElseIf c∊close
          :If 0=≢stack
              r←0
              :Leave
          :Else
              top←⊃¯1↑stack
              stack←¯1↓stack
              :If top≢open[close⍳c]
                  r←0
                  :Leave
              :EndIf
          :EndIf
      :EndIf
  :EndFor
  r←r∧0=≢stack
∇

lines←⊃⎕NGET '/dev/stdin' 1
results←{(Check ⍵)⊃'no' 'yes'}¨lines
⎕←∊{⍵,(⎕UCS 10)}¨results
