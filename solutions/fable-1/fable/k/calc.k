/ Expression calculator: recursive descent over a global string s with position p.
/ Grammar: E -> T (('+'|'-') T)* ; T -> F (('*'|'/') F)* ; F -> '(' E ')' | number

/ Truncating integer division, exact for 64-bit ints.
/ Work on absolute values (floor = truncate there), then fix the sign.
D:{ax:$[x<0;-x;x];ay:$[y<0;-y;y];m:ay!ax;n:ax-m;q:_n%ay;e:n-q*ay;q:q+_e%ay;$[(x<0)=(y<0);q;-q]}

dg:"0123456789"
ok:"0123456789+-*/()"

/ number: accumulate digits into x
NL:{$[|/s[p]=dg;[d:dg?s[p];p::p+1;NL[(10*x)+d]];x]}
/ factor
F:{$[s[p]="(";[p::p+1;a:E[];p::p+1;a];NL[0]]}
/ term tail: x is the value so far
TL:{$[|/s[p]="*/";[c:s[p];p::p+1;b:F[];TL[$[c="*";x*b;D[x;b]]]];x]}
T:{TL[F[]]}
/ expression tail
EL:{$[|/s[p]="+-";[c:s[p];p::p+1;b:T[];EL[$[c="+";x+b;x-b]]];x]}
E:{EL[T[]]}

/ evaluate one line: keep only meaningful chars, append sentinel
ev:{s::(x@&|/x=/:ok),"$";p::0;E[]}

r:0:"/dev/stdin"
/ keep only lines that contain something to evaluate (guard: x@&() misbehaves on empty)
k:$[0<#r;{0<#x@&|/x=/:ok}'r;0]
r:$[0<+/k;r@&k;()]
out:$[0<#r;`0:$ev'r;0]
