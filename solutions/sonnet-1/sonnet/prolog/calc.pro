main :-
    read_line_to_string(user_input, Line),
    loop(Line).

loop(end_of_file) :- !.
loop(Line) :-
    handle_line(Line),
    read_line_to_string(user_input, Next),
    loop(Next).

handle_line(Line) :-
    string_codes(Line, Codes),
    ( forall(member(C, Codes), code_type(C, space))
    -> true
    ;  tokenize(Codes, Tokens),
       phrase(expr(V), Tokens),
       format("~w~n", [V])
    ).

%% Tokenizer

tokenize(Codes, Tokens) :-
    phrase(tokens(Tokens), Codes).

tokens([Tok|Toks]) -->
    ws,
    tok(Tok),
    !,
    tokens(Toks).
tokens([]) --> ws.

ws --> [C], { code_type(C, space) }, !, ws.
ws --> [].

tok(num(N)) --> digits(Ds), { Ds \= [], number_codes(N, Ds) }.
tok('+') --> "+".
tok('-') --> "-".
tok('*') --> "*".
tok('/') --> "/".
tok('(') --> "(".
tok(')') --> ")".

digits([D|Ds]) --> [D], { code_type(D, digit) }, !, digits(Ds).
digits([]) --> [].

%% Parser / evaluator

expr(V) --> term(T), expr_rest(T, V).

expr_rest(Acc, V) --> ['+'], !, term(T), { Acc1 is Acc + T }, expr_rest(Acc1, V).
expr_rest(Acc, V) --> ['-'], !, term(T), { Acc1 is Acc - T }, expr_rest(Acc1, V).
expr_rest(Acc, Acc) --> [].

term(V) --> factor(F), term_rest(F, V).

term_rest(Acc, V) --> ['*'], !, factor(F), { Acc1 is Acc * F }, term_rest(Acc1, V).
term_rest(Acc, V) --> ['/'], !, factor(F), { int_div_trunc(Acc, F, Acc1) }, term_rest(Acc1, V).
term_rest(Acc, Acc) --> [].

factor(V) --> [num(V)], !.
factor(V) --> ['('], expr(V), [')'].

int_div_trunc(A, B, C) :-
    Q is truncate(A rdiv B),
    C = Q.
