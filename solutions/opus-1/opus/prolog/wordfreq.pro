main :-
    read_string(user_input, _, S),
    string_codes(S, Cs),
    words(Cs, Ws),
    msort(Ws, Sorted),
    count(Sorted, Pairs),
    predsort(cmp, Pairs, Out),
    forall(member(W-N, Out), format("~a ~d~n", [W, N])).

is_letter(C) :- C >= 0'a, C =< 0'z, !.
is_letter(C) :- C >= 0'A, C =< 0'Z.

lower(C, L) :- C >= 0'A, C =< 0'Z, !, L is C + 32.
lower(C, C).

words([], []).
words([C|Cs], Ws) :-
    (   is_letter(C)
    ->  take([C|Cs], W, Rest), atom_codes(A, W), Ws = [A|Ws1], words(Rest, Ws1)
    ;   words(Cs, Ws)
    ).

take([C|Cs], [L|W], Rest) :- is_letter(C), !, lower(C, L), take(Cs, W, Rest).
take(Rest, [], Rest).

count([], []).
count([W|Ws], [W-N|Ps]) :- run(W, Ws, 1, N, Rest), count(Rest, Ps).

run(W, [W|Ws], N0, N, Rest) :- !, N1 is N0 + 1, run(W, Ws, N1, N, Rest).
run(_, Rest, N, N, Rest).

cmp(O, W1-N1, W2-N2) :-
    (   N1 > N2 -> O = (<)
    ;   N1 < N2 -> O = (>)
    ;   compare(O, W1, W2)
    ).
