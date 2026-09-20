main :-
    read_line_to_codes(user_input, Codes),
    ( Codes == end_of_file -> Codes1 = [] ; Codes1 = Codes ),
    encode(Codes1, Parts),
    atomic_list_concat(Parts, Out),
    writeln(Out).

encode([], []).
encode([C|Cs], [Char, Len | Rest]) :-
    take_run(C, Cs, Rest0, Extra),
    Len is Extra + 1,
    char_code(Char, C),
    encode(Rest0, Rest).

take_run(C, [C|Cs], Rest, Count) :-
    !,
    take_run(C, Cs, Rest, Count0),
    Count is Count0 + 1.
take_run(_, Cs, Cs, 0).
