{
  t:" "vs x;
  i:0;
  v:0;
  o:"";

  num:{`i$x};

  {
    token:t[x];
    if[token="";:0];
    if[token in "+-*/";
      if[o<>"";
        $[o="*";v:v*num[t[i]];v:_(v%num[t[i]])];
      ];
      o:token;
      i:i+1;
    ;
      if[i=0 | t[i-1]="(";
        v:num[token];
        i:i+1;
      ;
        $[o="+";v:v+num[token];o="-";v:v-num[token];o="*";v:v*num[token];o="/";v:_(v%num[token])];
        i:i+1;
      ]
    ];
    0
  }/!#t;

  v
}each 0:"\n"
