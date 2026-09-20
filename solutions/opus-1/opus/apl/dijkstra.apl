⎕IO←0 ⋄ ⎕PP←17

∇ Main;x;N;M;E;s;t;S;D;W;o;cnt;st;inf;d;done;F;dF;m;X;r;idx;v;c;k;u
  x←⊃(//)⎕VFI∊' ',¨⊃⎕NGET'/dev/stdin' 1
  (N M)←2↑x
  E←(M,3)⍴(2+3×M)↑2↓x
  (s t)←¯2↑x
  :If s=t
      ⎕←0
      :Return
  :EndIf
  S←E[;0],E[;1] ⋄ D←E[;1],E[;0] ⋄ W←E[;2],E[;2]
  o←⍋S ⋄ S←S[o] ⋄ D←D[o] ⋄ W←W[o]
  st←S⍸(⍳N)-0.5 ⋄ st←1+st
  cnt←(1+S⍸⍳N)-st
  inf←1++/W
  d←N⍴inf ⋄ d[s]←0 ⋄ done←N⍴0 ⋄ F←,s
  :While 0<≢F
      dF←d[F] ⋄ m←⌊/dF
      X←(dF=m)/F ⋄ F←(dF≠m)/F
      done[X]←1
      :If done[t]
          :Leave
      :EndIf
      r←cnt[X]
      idx←(r/st[X])+(⍳+/r)-r/+\0,¯1↓r
      v←D[idx] ⋄ c←m+W[idx]
      k←(~done[v])∧c<d[v]
      v←k/v ⋄ c←k/c
      :If 0<≢v
          u←∪v
          d[u]←v{⌊/⍵}⌸c
          F←∪F,u
      :EndIf
  :EndWhile
  ⎕←('¯'⎕R'-')⍕done[t]⊃¯1,d[t]
∇

Main
