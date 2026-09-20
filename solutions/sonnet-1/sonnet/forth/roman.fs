\ Roman numeral converter

create values 1000 , 900 , 500 , 400 , 100 , 90 , 50 , 40 , 10 , 9 , 5 , 4 , 1 ,

: p-M   S" M"  type ;
: p-CM  S" CM" type ;
: p-D   S" D"  type ;
: p-CD  S" CD" type ;
: p-C   S" C"  type ;
: p-XC  S" XC" type ;
: p-L   S" L"  type ;
: p-XL  S" XL" type ;
: p-X   S" X"  type ;
: p-IX  S" IX" type ;
: p-V   S" V"  type ;
: p-IV  S" IV" type ;
: p-I   S" I"  type ;

create printers
  ' p-M , ' p-CM , ' p-D , ' p-CD , ' p-C , ' p-XC , ' p-L , ' p-XL ,
  ' p-X , ' p-IX , ' p-V , ' p-IV , ' p-I ,

: print-roman ( n -- )
    13 0 do
        begin
            dup i cells values + @ >=
        while
            i cells values + @ -
            i cells printers + @ execute
        repeat
    loop
    drop ;

: main
    begin
        pad 256 stdin read-line throw
    while
        pad swap 0 0 2swap >number 2drop drop
        print-roman cr
    repeat
    drop ;

main
bye
