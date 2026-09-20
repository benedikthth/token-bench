main :-
    read_string(user_input, _, Str),
    split_string(Str, " \t\r\n", " \t\r\n", Parts),
    ( member(P, Parts), P \== "", number_string(N0, P) -> N = N0 ; N = 0 ),
    primes_upto(N, Ps),
    atomic_list_concat(Ps, ' ', Line),
    format("~w~n", [Line]).

primes_upto(N, Ps) :-
    ( N < 2 -> Ps = []
    ; M is N + 1,
      functor(S, s, M),
      Limit is floor(sqrt(N)),
      sieve(2, Limit, N, S),
      collect(2, N, S, Ps)
    ).

sieve(I, Limit, _, _) :- I > Limit, !.
sieve(I, Limit, N, S) :-
    I1 is I + 1,
    ( arg(I1, S, X), X == c -> true
    ; Start is I * I,
      mark(Start, I, N, S)
    ),
    I2 is I + 1,
    sieve(I2, Limit, N, S).

mark(J, _, N, _) :- J > N, !.
mark(J, I, N, S) :-
    J1 is J + 1,
    ( arg(J1, S, X), var(X) -> X = c ; true ),
    J2 is J + I,
    mark(J2, I, N, S).

collect(I, N, _, []) :- I > N, !.
collect(I, N, S, Ps) :-
    I1 is I + 1,
    arg(I1, S, X),
    ( var(X) -> Ps = [I|Rest] ; Ps = Rest ),
    I2 is I + 1,
    collect(I2, N, S, Rest).
