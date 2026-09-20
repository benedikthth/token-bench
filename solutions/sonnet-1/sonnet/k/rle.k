x:*0:"/dev/stdin"
n:#x
r:$[n=0;"";[idx:&1,~(1_x)=(-1_x);a:idx,n;lens:(1_a)-(-1_a);letters:x@idx;,/letters,'$:'lens]]
"/dev/stdout" 0:,r
