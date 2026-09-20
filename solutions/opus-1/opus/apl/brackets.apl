step←{
    0≡⍵:0
    ⍺∊'([{':⍵,⍺
    0=≢⍵:0
    (⊃⌽⍵)≠'([{'⌷⍨')]}'⍳⍺:0
    ¯1↓⍵
}
bal←{''≡⊃step/(⌽⍵~⎕UCS 13),⊂''}
lines←⊃⎕NGET'/dev/stdin'1
out←∊(('no' 'yes')[1+bal¨lines]),¨⎕UCS 10
tie←'/dev/stdout'⎕NTIE 0 1
out ⎕NAPPEND tie 80
⎕NUNTIE tie
