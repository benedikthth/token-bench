check: {
  stack:: "";
  {
    if[x in "([{"; stack:: stack, x];
    if[x = ")"; if[0 < #stack; if[stack[#stack-1] = "("; stack:: stack[!#stack-1]]]];
    if[x = "]"; if[0 < #stack; if[stack[#stack-1] = "["; stack:: stack[!#stack-1]]]];
    if[x = "}"; if[0 < #stack; if[stack[#stack-1] = "{"; stack:: stack[!#stack-1]]]]
  } each x;
  0 = #stack
};

lines: 0:
{-1 $[check[x]; "yes"; "no"]} each lines
