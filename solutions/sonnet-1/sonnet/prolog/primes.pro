:- dynamic composite/1.

main :-
    read_line_to_string(user_input, Line),
    split_string(Line, "", " \t\r\n", [Trimmed]),
    number_string(N, Trimmed),
    sieve(N, Primes),
    atomic_list_concat(Primes, ' ', Out),
    writeln(Out).

sieve(N, Primes) :-
    ( N < 2
    -> Primes = []
    ;  retractall(composite(_)),
       mark_composites(2, N),
       findall(P, (between(2, N, P), \+ composite(P)), Primes)
    ).

mark_composites(I, N) :-
    ( I * I > N
    -> true
    ;  ( composite(I) -> true ; mark_multiples(I, I, N) ),
       I1 is I + 1,
       mark_composites(I1, N)
    ).

mark_multiples(I, J, N) :-
    Start is J * I,
    ( Start > N
    -> true
    ;  do_mark(Start, I, N)
    ).

do_mark(K, I, N) :-
    ( K > N
    -> true
    ;  ( composite(K) -> true ; assertz(composite(K)) ),
       K1 is K + I,
       do_mark(K1, I, N)
    ).
