vals ← 1000‿900‿500‿400‿100‿90‿50‿40‿10‿9‿5‿4‿1
syms ← "M"‿"CM"‿"D"‿"CD"‿"C"‿"XC"‿"L"‿"XL"‿"X"‿"IX"‿"V"‿"IV"‿"I"
Roman ← {𝕩=0 ? "" ; i←⊑/vals≤𝕩 ⋄ (i⊑syms)∾𝕊 𝕩-i⊑vals}
Parse ← {10⊸×⊸+˜´⌽ '0'-˜𝕩}
text ← •FChars "/dev/stdin"
lines ← (@+10) ((⊢-˜+`×¬)∘=⊔⊢) text
lines ↩ {(𝕩≥'0')/𝕩}¨ lines
lines ↩ (0<≠¨)⊸/ lines
•Out¨ Roman∘Parse¨ lines
