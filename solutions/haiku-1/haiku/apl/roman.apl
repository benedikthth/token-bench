values ← 1000 900 500 400 100 90 50 40 10 9 5 4 1
symbols ← 'M' 'CM' 'D' 'CD' 'C' 'XC' 'L' 'XL' 'X' 'IX' 'V' 'IV' 'I'

∇ result ← toRoman num
    result ← ''
    :For i :In ⍳⍴values
        count ← ⌊num ÷ values[i]
        :If count > 0
            result ← result, (count⍴symbols[i])
            num ← num - count × values[i]
        :EndIf
    :EndFor
∇

∇ processInput
    line ← ⎕
    roman ← toRoman ⍎line
    out ← roman, (⎕AV[3])
    ⎕ ← out
    processInput
∇

:Trap 0
    processInput
:EndTrap
