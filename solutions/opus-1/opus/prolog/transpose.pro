main :-
    read_string(user_input, _, S),
    split_string(S, " \t\r\n", " \t\r\n", Parts),
    exclude(==(""), Parts, Toks),
    maplist(number_string, Ns, Toks),
    Ns = [R, C | Rest],
    rows(R, C, Rest, Rows),
    cols(C, Rows).

rows(0, _, _, []) :- !.
rows(R, C, L, [Row|Rows]) :-
    length(Row, C),
    append(Row, L1, L),
    R1 is R - 1,
    rows(R1, C, L1, Rows).

split_head([H|T], H, T).

cols(0, _) :- !.
cols(C, Rows) :-
    maplist(split_head, Rows, Col, Rest),
    atomic_list_concat(Col, ' ', A),
    writeln(A),
    C1 is C - 1,
    cols(C1, Rest).
