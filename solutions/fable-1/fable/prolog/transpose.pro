main :-
    read_line_to_string(user_input, Header),
    split_string(Header, " \t", " \t\r", HeaderParts),
    exclude(==(""), HeaderParts, [RS, CS]),
    number_string(R, RS),
    number_string(C, CS),
    read_rows(R, Rows),
    transpose_matrix(C, Rows, Cols),
    forall(member(Col, Cols), print_row(Col)).

read_rows(0, []) :- !.
read_rows(N, [Row|Rows]) :-
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  Row = []
    ;   split_string(Line, " \t", " \t\r", Parts0),
        exclude(==(""), Parts0, Parts),
        maplist(number_string, Row, Parts)
    ),
    N1 is N - 1,
    read_rows(N1, Rows).

transpose_matrix(0, _, []) :- !.
transpose_matrix(C, Rows, [Col|Cols]) :-
    maplist(head_tail, Rows, Col, Rests),
    C1 is C - 1,
    transpose_matrix(C1, Rests, Cols).

head_tail([H|T], H, T).

print_row(Row) :-
    atomic_list_concat(Row, ' ', Atom),
    format("~w~n", [Atom]).
