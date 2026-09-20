:- use_module(library(readutil)).

main :-
    read_line_to_codes(user_input, Line),
    (   Line == end_of_file
    ->  true
    ;   process_line(Line),
        main
    ).

process_line(Line) :-
    exclude(is_space_code, Line, Codes),
    (   Codes == []
    ->  true
    ;   phrase(expr(V), Codes)
    ->  format("~d~n", [V])
    ;   true
    ).

is_space_code(C) :- code_type(C, space).

expr(V) --> term(T), expr_rest(T, V).

expr_rest(Acc, V) --> "+", !, term(T), { A1 is Acc + T }, expr_rest(A1, V).
expr_rest(Acc, V) --> "-", !, term(T), { A1 is Acc - T }, expr_rest(A1, V).
expr_rest(V, V) --> [].

term(V) --> factor(F), term_rest(F, V).

term_rest(Acc, V) --> "*", !, factor(F), { A1 is Acc * F }, term_rest(A1, V).
term_rest(Acc, V) --> "/", !, factor(F), { A1 is Acc // F }, term_rest(A1, V).
term_rest(V, V) --> [].

factor(V) --> "(", !, expr(V), ")".
factor(V) --> digits(Ds), { Ds \== [], number_codes(V, Ds) }.

digits([D|Ds]) --> [D], { code_type(D, digit) }, !, digits(Ds).
digits([]) --> [].
