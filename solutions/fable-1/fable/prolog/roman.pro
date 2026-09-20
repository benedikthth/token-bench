pairs([1000-"M", 900-"CM", 500-"D", 400-"CD", 100-"C", 90-"XC",
       50-"L", 40-"XL", 10-"X", 9-"IX", 5-"V", 4-"IV", 1-"I"]).

roman(0, _, []) :- !.
roman(N, [V-S|Rest], Out) :-
    (   N >= V
    ->  N1 is N - V,
        string_codes(S, Codes),
        append(Codes, Tail, Out),
        roman(N1, [V-S|Rest], Tail)
    ;   roman(N, Rest, Out)
    ).

main :-
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  true
    ;   normalize_space(string(Trim), Line),
        (   Trim == ""
        ->  true
        ;   number_string(N, Trim),
            pairs(P),
            roman(N, P, Codes),
            format("~s~n", [Codes])
        ),
        main
    ).
