op:"([{"
cl:")]}"
r:{[a;c]
ok:*a; st:1_a;
isOpen:|/c=op; isClose:|/c=cl;
oi:op?c; ci:cl?c;
top:$[0=#st;-1;*|st];
match:top=ci+1;
newok:$[isClose;ok&(0<#st)&match;ok];
newst:$[isOpen;st,oi+1;$[isClose;$[0=#st;st;-1_st];st]];
newok,newst}
bal:{[s] a:r/[,1;s]; (*a)&0=#(1_a)}
L:0:0
out:{$[x;"yes";"no"]}'bal'L
`0:out
