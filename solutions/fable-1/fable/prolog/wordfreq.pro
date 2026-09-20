:- set_prolog_flag(double_quotes, codes).

main :-
    read_all(Codes),
    words(Codes, Words),
    msort(Words, Sorted),
    count_runs(Sorted, Counts),
    predsort(order, Counts, Ordered),
    forall(member(C-W, Ordered),
           ( atom_codes(A, W), format("~w ~d~n", [A, C]) )).

read_all(Codes) :-
    read_stream_to_codes(user_input, Codes).

letter(C) :- C >= 0'a, C =< 0'z.
letter(C) :- C >= 0'A, C =< 0'Z.

lower(C, L) :- C >= 0'A, C =< 0'Z, !, L is C + 32.
lower(C, C).

words([], []).
words([C|Cs], Words) :-
    (   letter(C)
    ->  take_word([C|Cs], W, Rest),
        Words = [W|Ws],
        words(Rest, Ws)
    ;   words(Cs, Words)
    ).

take_word([C|Cs], [L|Ls], Rest) :-
    letter(C), !,
    lower(C, L),
    take_word(Cs, Ls, Rest).
take_word(Rest, [], Rest).

count_runs([], []).
count_runs([W|Ws], [N-W|Rest]) :-
    take_same(W, Ws, 1, N, Tail),
    count_runs(Tail, Rest).

take_same(W, [W|Ws], N0, N, Tail) :- !,
    N1 is N0 + 1,
    take_same(W, Ws, N1, N, Tail).
take_same(_, Tail, N, N, Tail).

order(Ord, C1-W1, C2-W2) :-
    (   C1 > C2 -> Ord = (<)
    ;   C1 < C2 -> Ord = (>)
    ;   compare(Ord, W1, W2)
    ).
