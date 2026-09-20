:- initialization(main).

main :-
    read_stream_to_codes(user_input, Codes),
    split_words(Codes, WordCodesList),
    maplist(lower_word, WordCodesList, Atoms),
    msort(Atoms, Sorted),
    group_counts(Sorted, Pairs),
    predsort(compare_pairs, Pairs, Ordered),
    print_pairs(Ordered).

is_ascii_alpha(C) :- C >= 0'a, C =< 0'z.
is_ascii_alpha(C) :- C >= 0'A, C =< 0'Z.

split_words(Codes, Words) :-
    scan(Codes, [], Words).

scan([], Cur, Words) :-
    ( Cur == [] -> Words = [] ; reverse(Cur, W), Words = [W] ).
scan([C|Cs], Cur, Words) :-
    ( is_ascii_alpha(C) ->
        scan(Cs, [C|Cur], Words)
    ; ( Cur == [] ->
        scan(Cs, [], Words)
      ; reverse(Cur, W),
        scan(Cs, [], Rest),
        Words = [W|Rest]
      )
    ).

lower_code(C, L) :- ( C >= 0'A, C =< 0'Z -> L is C + 32 ; L = C ).

lower_word(Codes, Atom) :-
    maplist(lower_code, Codes, LCodes),
    atom_codes(Atom, LCodes).

group_counts([], []).
group_counts([W|Ws], [W-N|Rest]) :-
    take_same(Ws, W, Same, Remaining),
    length(Same, M),
    N is M + 1,
    group_counts(Remaining, Rest).

take_same([X|Xs], W, [X|Same], Rest) :-
    X == W,
    !,
    take_same(Xs, W, Same, Rest).
take_same(Xs, _, [], Xs).

compare_pairs(Order, W1-C1, W2-C2) :-
    ( C1 > C2 -> Order = (<)
    ; C1 < C2 -> Order = (>)
    ; compare(Order, W1, W2)
    ).

print_pairs([]).
print_pairs([W-C|Rest]) :-
    format("~w ~w~n", [W, C]),
    print_pairs(Rest).
