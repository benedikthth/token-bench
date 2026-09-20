:- initialization(true).

main :-
    read_string(user_input, _, S),
    split_string(S, " \t\r\n", " \t\r\n", Parts),
    exclude(==(""), Parts, Tokens),
    (   Tokens = [T|_]
    ->  number_string(N, T)
    ;   N = 0
    ),
    primes(N, Ps),
    atomic_list_concat(Ps, ' ', A),
    write(A), nl.

primes(N, []) :- N < 2, !.
primes(N, Ps) :-
    functor(A, a, N),
    sieve(2, N, A),
    findall(I, (between(2, N, I), arg(I, A, V), var(V)), Ps).

sieve(I, N, _) :- I * I > N, !.
sieve(I, N, A) :-
    (   arg(I, A, V), var(V)
    ->  S is I * I, mark(S, I, N, A)
    ;   true
    ),
    I1 is I + 1,
    sieve(I1, N, A).

mark(J, _, N, _) :- J > N, !.
mark(J, I, N, A) :-
    nb_setarg(J, A, x),
    J1 is J + I,
    mark(J1, I, N, A).
