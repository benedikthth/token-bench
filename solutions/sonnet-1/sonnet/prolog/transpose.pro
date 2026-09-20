:- initialization(main).

main :-
    read_line_to_string(user_input, Line0),
    split_string(Line0, " ", " ", Parts0),
    maplist(number_string, [R, C], Parts0),
    read_rows(R, Rows),
    transpose_matrix(Rows, C, Cols),
    maplist(print_row, Cols).

read_rows(0, []) :- !.
read_rows(N, [Row|Rows]) :-
    N > 0,
    read_line_to_string(user_input, Line),
    split_string(Line, " ", " ", Parts),
    maplist(number_string, Row, Parts),
    N1 is N - 1,
    read_rows(N1, Rows).

transpose_matrix(_, 0, []) :- !.
transpose_matrix(Rows, C, [Col|Cols]) :-
    C > 0,
    maplist(nth1_first, Rows, Col, Rests),
    C1 is C - 1,
    transpose_matrix(Rests, C1, Cols).

nth1_first([X|Xs], X, Xs).

print_row(Row) :-
    maplist(number_string, Row, Strs),
    atomic_list_concat(Strs, ' ', Line),
    writeln(Line).
