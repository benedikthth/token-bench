:- set_prolog_flag(double_quotes, codes).

main :-
    prompt(_, ''),
    read_lines.

read_lines :-
    read_line_to_codes(user_input, Line),
    (   Line == end_of_file
    ->  true
    ;   strip_cr(Line, Clean),
        (   balanced(Clean, [])
        ->  writeln(yes)
        ;   writeln(no)
        ),
        read_lines
    ).

strip_cr(Line, Clean) :-
    (   append(Clean, [0'\r], Line)
    ->  true
    ;   Clean = Line
    ).

balanced([], []).
balanced([C|Cs], Stack) :-
    (   open_close(C, Close)
    ->  balanced(Cs, [Close|Stack])
    ;   Stack = [C|Rest]
    ->  balanced(Cs, Rest)
    ;   fail
    ).

open_close(0'(, 0')).
open_close(0'[, 0']).
open_close(0'{, 0'}).
