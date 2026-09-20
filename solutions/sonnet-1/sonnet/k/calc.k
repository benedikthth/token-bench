isdigit:{~^"0123456789"?x}

skipsp:{$[s[p]=" ";skipsp1[];0]}
skipsp1:{p::p+1;skipsp[]}

numloop:{$[isdigit[s[p]];numloop1[];0]}
numloop1:{nv::nv*10+(s[p]-"0");p::p+1;numloop[]}
parseNumber:{nv::0;numloop[];nv}

s::"123~"
p::0
`0:,$parseNumber[];
`0:,$p;
