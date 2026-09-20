OPEN:"([{"
CLOSE:")]}"
step:{[st;c] ok:st[0];stk:st[1]; isopen:|/c=OPEN; $[~ok;st;isopen;(1;stk,c);(#stk)=0;(0;stk);(OPEN[CLOSE?c])=*|stk;(1;-1_stk);(0;stk)]}
bal:{[s]
  r:(1;"")step/s;
  :(r[0])&(#r[1])=0
  }
`0:,$bal"()"
`0:,$bal"([])"
`0:,$bal"(]"
`0:,$bal"((("
`0:,$bal"([)]"
`0:,$bal""
