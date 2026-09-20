main :-
    read_line_to_string(user_input, L),
    (   L == end_of_file
    ->  true
    ;   string_codes(L, Cs0),
        exclude(==(0'\r), Cs0, Cs),
        (   bal(Cs, []) -> writeln(yes) ; writeln(no) ),
        main
    ).

pair(0'(, 0')).
pair(0'[, 0']).
pair(0'{, 0'}).

bal([], []).
bal([C|Cs], St) :-
    (   pair(C, Close)
    ->  bal(Cs, [Close|St])
    ;   St = [C|Rest],
        bal(Cs, Rest)
    ).
