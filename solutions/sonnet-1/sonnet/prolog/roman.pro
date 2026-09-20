:- initialization(main).

values([
    1000-'M', 900-'CM', 500-'D', 400-'CD',
    100-'C', 90-'XC', 50-'L', 40-'XL',
    10-'X', 9-'IX', 5-'V', 4-'IV', 1-'I'
]).

to_roman(0, '') :- !.
to_roman(N, Roman) :-
    values(Values),
    member(V-S, Values),
    V =< N,
    !,
    N1 is N - V,
    to_roman(N1, Rest),
    atom_concat(S, Rest, Roman).

main :-
    read_line_to_string(user_input, Line),
    process(Line),
    halt.

process(end_of_file) :- !.
process(Line) :-
    ( normalize_space(atom(A), Line), A \== '' ->
        atom_number(A, N),
        to_roman(N, Roman),
        writeln(Roman)
    ; true
    ),
    read_line_to_string(user_input, Next),
    process(Next).
