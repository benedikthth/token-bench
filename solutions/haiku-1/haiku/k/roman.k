roman: {
  values: 1000 900 500 400 100 90 50 40 10 9 5 4 1;
  symbols: ("M"; "CM"; "D"; "CD"; "C"; "XC"; "L"; "XL"; "X"; "IX"; "V"; "IV"; "I");
  result: "";
  n: x;
  i: 0;
  while[i < 13;
    while[n >= values[i];
      result: result, symbols[i];
      n: n - values[i]
    ];
    i: i + 1
  ];
  result
}

{-1 roman _ x}' read 0
