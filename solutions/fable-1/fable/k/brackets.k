/ balanced brackets: fold each line through a stack; "x" is a poison marker on mismatch
g:{[s;c] i:")]}"?c; $[^i;s,c;0=#s;s,"x";(*|s)="([{"@i;(-1)_s;s,"x"]}
b:{$[0=#""g/x;"yes";"no"]}
`0:,/(b'0:"/dev/stdin"),\:"\n"
