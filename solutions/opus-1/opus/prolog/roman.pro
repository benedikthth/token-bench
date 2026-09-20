main :-
    read_lines(Lines),
    forall(member(L, Lines), process(L)).

read_lines(Lines) :-
    read_line_to_string(user_input, S),
    (   S == end_of_file
    ->  Lines = []
    ;   Lines = [S|Rest],
        read_lines(Rest)
    ).

process(S) :-
    normalize_space(string(T), S),
    (   T == ""
    ->  true
    ;   number_string(N, T),
        roman(N, R),
        format("~s~n", [R])
    ).

pair(1000, "M").
pair(900, "CM").
pair(500, "D").
pair(400, "CD").
pair(100, "C").
pair(90, "XC").
pair(50, "L").
pair(40, "XL").
pair(10, "X").
pair(9, "IX").
pair(5, "V").
pair(4, "IV").
pair(1, "I").

roman(0, []) :- !.
roman(N, R) :-
    pair(V, S),
    N >= V, !,
    N1 is N - V,
    roman(N1, R1),
    string_codes(S, C),
    append(C, R1, R).
