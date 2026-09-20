% Tokenizer
tokenize(Input, Tokens) :-
    string_codes(Input, Codes),
    tokenize_codes(Codes, Tokens).

tokenize_codes([], []).
tokenize_codes([C|Cs], Tokens) :-
    C = 32,  % space
    !,
    tokenize_codes(Cs, Tokens).
tokenize_codes([C|Cs], Tokens) :-
    between(48, 57, C),  % digit 0-9
    !,
    collect_number_codes([C|Cs], NumCodes, Rest),
    number_codes(Num, NumCodes),
    Tokens = [num(Num)|MoreTokens],
    tokenize_codes(Rest, MoreTokens).
tokenize_codes([C|Cs], Tokens) :-
    member(C, [43, 45, 42, 47, 40, 41]),  % +, -, *, /, (, )
    atom_codes(Op, [C]),
    Tokens = [Op|MoreTokens],
    tokenize_codes(Cs, MoreTokens).

collect_number_codes([C|Cs], [C|NumCodes], Rest) :-
    between(48, 57, C),
    !,
    collect_number_codes(Cs, NumCodes, Rest).
collect_number_codes(Cs, [], Cs).

% Parser with standard precedence: * / before + -
parse_expr(Tokens, Expr, Rest) :-
    parse_add_expr(Tokens, Expr, Rest).

parse_add_expr(Tokens, Expr, Rest) :-
    parse_mul_expr(Tokens, Left, Rest1),
    parse_add_ops(Rest1, Left, Expr, Rest).

parse_add_ops(Tokens, Left, Expr, Rest) :-
    Tokens = [Op|Rest1],
    member(Op, ['+', '-']),
    !,
    parse_mul_expr(Rest1, Right, Rest2),
    NewExpr =.. [Op, Left, Right],
    parse_add_ops(Rest2, NewExpr, Expr, Rest).
parse_add_ops(Tokens, Left, Left, Tokens).

parse_mul_expr(Tokens, Expr, Rest) :-
    parse_primary(Tokens, Left, Rest1),
    parse_mul_ops(Rest1, Left, Expr, Rest).

parse_mul_ops(Tokens, Left, Expr, Rest) :-
    Tokens = [Op|Rest1],
    member(Op, ['*', '/']),
    !,
    parse_primary(Rest1, Right, Rest2),
    NewExpr =.. [Op, Left, Right],
    parse_mul_ops(Rest2, NewExpr, Expr, Rest).
parse_mul_ops(Tokens, Left, Left, Tokens).

parse_primary(Tokens, Expr, Rest) :-
    Tokens = [num(N)|Rest1],
    !,
    Expr = N,
    Rest = Rest1.
parse_primary(Tokens, Expr, Rest) :-
    Tokens = ['('|Rest1],
    !,
    parse_expr(Rest1, Expr, Rest2),
    Rest2 = [')'|Rest].

% Evaluator
eval(N, N) :-
    integer(N), !.
eval(Expr, Result) :-
    Expr =.. [Op, Left, Right],
    eval(Left, LeftVal),
    eval(Right, RightVal),
    apply_op(Op, LeftVal, RightVal, Result).

apply_op('+', L, R, Result) :- Result is L + R.
apply_op('-', L, R, Result) :- Result is L - R.
apply_op('*', L, R, Result) :- Result is L * R.
apply_op('/', L, R, Result) :- Result is truncate(L / R).

% Main entry point
main :-
    read_string(user_input, "", "", _, Input),
    split_string(Input, "\n", "\n", Lines),
    maplist(process_line_safe, Lines).

process_line_safe("") :- !.
process_line_safe(Line) :-
    tokenize(Line, Tokens),
    parse_expr(Tokens, Expr, []),
    eval(Expr, Result),
    write(Result), nl.
