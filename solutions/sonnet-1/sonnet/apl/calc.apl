⎕IO←1

∇toks←Tokenize ln;valid;s;i;n;j;c
  valid←⎕D,'+-*/()'
  s←(ln∊valid)/ln
  toks←⍬
  i←1
  n←≢s
  :While i≤n
      c←s[i]
      :If c∊⎕D
          j←i
          :While (j≤n)∧(s[j]∊⎕D)
              j←j+1
          :EndWhile
          toks←toks,⊂s[(i-1)+⍳j-i]
          i←j
      :Else
          toks←toks,⊂c
          i←i+1
      :EndIf
  :EndWhile
∇

⎕←Tokenize '1 + 2'
