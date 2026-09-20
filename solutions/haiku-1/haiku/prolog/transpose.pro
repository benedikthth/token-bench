main :-
    read_line_to_string(user_input, Line1),
    split_string(Line1, " ", " ", RCParts),
    maplist(number_string, [R, C], RCParts),
    read_matrix(R, C, Matrix),
    transpose(Matrix, Transposed),
    print_matrix(Transposed).

read_matrix(0, _, []).
read_matrix(N, C, [Row|Rows]) :-
    N > 0,
    read_line_to_string(user_input, Line),
    split_string(Line, " ", " ", Parts),
    maplist(number_string, Row, Parts),
    N1 is N - 1,
    read_matrix(N1, C, Rows).

% Transpose a matrix
transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rest]) :-
    maplist(get_head, Matrix, Row),
    maplist(get_tail, Matrix, Stripped),
    transpose(Stripped, Rest).

get_head([H|_], H).
get_tail([_|T], T).

print_matrix([]).
print_matrix([Row|Rows]) :-
    print_row(Row),
    print_matrix(Rows).

print_row([]).
print_row([X]) :-
    write(X), nl.
print_row([X|Xs]) :-
    Xs \= [],
    write(X), write(' '),
    print_row(Xs).
