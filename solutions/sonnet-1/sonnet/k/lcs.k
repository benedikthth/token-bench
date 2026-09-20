rowStep:{[s2;dp;c]
  eq:s2=c;
  prev:0,(-1)_dp;
  cand:(eq*(prev+1))+(1-eq)*dp;
  |\cand}

L:0:0
nl:#L
s1:$[nl>0;L[0];""]
s2:$[nl>1;L[1];""]
n:#s1
m:#s2
dp0:m#0
dpf:$[(n=0)|(m=0);dp0;rowStep[s2]/[dp0;s1]]
ans:$[m=0;0;dpf[m-1]]
`0:,$ans
