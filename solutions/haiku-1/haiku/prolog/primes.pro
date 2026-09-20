main :-
    read_string(user_input, "\n", " \t", _, Line),
    string_codes(Line, Codes),
    number_codes(N, Codes),
    findall(P, (between(2, N, P), is_prime(P)), Primes),
    write_primes(Primes).

% Check if a number is prime
is_prime(2).
is_prime(3).
is_prime(N) :-
    N > 3,
    N mod 2 =\= 0,
    N mod 3 =\= 0,
    is_prime_aux(N, 5).

% Helper for checking divisibility by numbers of form 6k+1 and 6k-1
is_prime_aux(N, F) :-
    F * F > N, !.
is_prime_aux(N, F) :-
    N mod F =\= 0,
    F2 is F + 2,
    N mod F2 =\= 0,
    F3 is F + 6,
    is_prime_aux(N, F3).

% Output primes separated by spaces
write_primes([]) :-
    nl.
write_primes(Primes) :-
    atomic_list_concat(Primes, ' ', Output),
    write(Output),
    nl.
