thousands:("";"M";"MM";"MMM")
hundreds:("";"C";"CC";"CCC";"CD";"D";"DC";"DCC";"DCCC";"CM")
tens:("";"X";"XX";"XXX";"XL";"L";"LX";"LXX";"LXXX";"XC")
ones:("";"I";"II";"III";"IV";"V";"VI";"VII";"VIII";"IX")

roman:{[n]
  th:_n%1000;
  n:1000!n;
  h:_n%100;
  n:100!n;
  t:_n%10;
  o:10!n;
  thousands[th],hundreds[h],tens[t],ones[o]}

lines:0:0
`0:roman'{.x}'lines
