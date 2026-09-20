main :-
    read_line_to_codes(user_input, Line0),
    ( Line0 == end_of_file -> Line = [] ; Line = Line0 ),
    exclude([C]>>(C =:= 0'\r), Line, Codes),
    rle(Codes, Out),
    format("~s~n", [Out]).

rle([], []).
rle([C|Cs], Out) :-
    run(C, Cs, 1, N, Rest),
    number_codes(N, NC),
    append([C|NC], Tail, Out),
    rle(Rest, Tail).

run(C, [C|Cs], N0, N, Rest) :- !,
    N1 is N0 + 1,
    run(C, Cs, N1, N, Rest).
run(_, Rest, N, N, Rest).
