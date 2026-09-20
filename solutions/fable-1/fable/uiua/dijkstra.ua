P     ← ⊜⋕⊸≠@\s
NM    ← P &sc
N     ← ⊡0 NM
M     ← ⊡1 NM
A     ← ⍥(˜⊂ P &sc) +1 M []
ST    ← ↙¯2 A
E     ← ⍉ ↯ ⊟ M 3 ↘¯2 A
U     ← ⊂ ⊡0 E ⊡1 E
V     ← ⊂ ⊡1 E ⊡0 E
W     ← ⊂ ⊡2 E ⊡2 E
T     ← ⊂ ⇡N V
Relax ← ⊕/↧ T ⊂⟜(+W ⊏U)
D     ← ⍥Relax N ⊏ ≠⊡0 ST ⇡N [0 ∞]
&p ⨬(∘|⋅¯1) =∞ ⟜∘ ⊡ ⊡1 ST D
