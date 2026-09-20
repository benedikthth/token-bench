s←{0::'' ⋄ ⊃⎕NGET'/dev/stdin'}0
s←s/⍨s∊⎕C ⎕A
b←s≠¯1↓' ',s
⎕←∊{(⊃⍵),⍕≢⍵}¨b⊂s
