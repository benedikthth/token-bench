vals:1000 900 500 400 100 90 50 40 10 9 5 4 1
syms:("M";"CM";"D";"CD";"C";"XC";"L";"XL";"X";"IX";"V";"IV";"I")
inner:{[n;i;out]$[~n<vals[i];inner[n-vals[i];i;out,syms[i]];$[i<12;inner[n;i+1;out];out]]}
roman:{inner[x;0;""]}
l:0:"/dev/stdin"
`0:roman'.'l
