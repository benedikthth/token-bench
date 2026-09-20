⍝ Expression Calculator

eval_expr ← {
    expr ← ⍵ ~ ' '
    tokens ← make_tokens expr
    res ← add_sub tokens 1
    ⌊res[1]
}

make_tokens ← {
    expr ← ⍵
    tokens ← ⍬
    i ← 0
    :While i < ≢expr
        c ← expr[i+1]
        :If c ∈ '()+-*/'
            tokens ← tokens,⊂c
            i ← i+1
        :Else
            j ← i
            :While j < ≢expr ∧ expr[j+1] ∈ '0123456789'
                j ← j+1
            :EndWhile
            n ← ⍎expr[(i+1)..j]
            tokens ← tokens,⊂n
            i ← j+1
        :EndIf
    :EndWhile
    tokens
}

add_sub ← {
    tokens ← ⍵[1]
    idx ← ⍵[2]
    res ← mul_div tokens (idx+1)
    val ← res[1]
    idx ← res[2]
    :While idx ≤ ≢tokens
        t ← ⊃tokens[idx]
        :If t ≡ '+' ∨ t ≡ '-'
            res ← mul_div tokens (idx+2)
            r ← res[1]
            idx ← res[2]
            :If t ≡ '+'
                val ← val+r
            :Else
                val ← val-r
            :EndIf
        :Else
            :Leave
        :EndIf
    :EndWhile
    (val,idx)
}

mul_div ← {
    tokens ← ⍵[1]
    idx ← ⍵[2]
    res ← primary tokens idx
    val ← res[1]
    idx ← res[2]
    :While idx ≤ ≢tokens
        t ← ⊃tokens[idx]
        :If t ≡ '*' ∨ t ≡ '/'
            res ← primary tokens (idx+1)
            r ← res[1]
            idx ← res[2]
            :If t ≡ '*'
                val ← val×r
            :Else
                val ← (⌊|val÷r)×(×val÷r)
            :EndIf
        :Else
            :Leave
        :EndIf
    :EndWhile
    (val,idx)
}

primary ← {
    tokens ← ⍵[1]
    idx ← ⍵[2]
    t ← ⊃tokens[idx]
    :If t ≡ '('
        res ← add_sub tokens (idx+1)
        val ← res[1]
        idx ← res[2]+1
    :Else
        val ← t
        idx ← idx+1
    :EndIf
    (val,idx)
}

⍝ Read all lines and process
:Trap 0
    input ← ⎕NREAD 0 82 ¯1
:Else
    input ← ''
:EndTrap

lines ← ⊃⎕SL input
:For line :In lines
    :If 0 < ≢line
        ⎕ ← eval_expr line
    :EndIf
:EndFor
