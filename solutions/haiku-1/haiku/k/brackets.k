f:{s:x;c:y;
  if[c="(";s:s,c];
  if[c="[";s:s,c];
  if[c="{";s:s,c];
  if[c=")";if[#s;if[s[-1]="(";s:(-1)_s]]];
  if[c="]";if[#s;if[s[-1]="[";s:(-1)_s]]];
  if[c="}";if[#s;if[s[-1]="{";s:(-1)_s]]];
  s}

{if[0=#(f/)x;"yes";"no"]} each 1:"lines"
