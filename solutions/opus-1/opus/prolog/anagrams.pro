main :-
    read_string(user_input, _, S),
    split_string(S, "\n", " \r\t", Lines),
    exclude(==(""), Lines, Ws),
    maplist(keyed, Ws, Pairs),
    keysort(Pairs, Sorted),
    group_pairs_by_key(Sorted, Groups),
    maplist(group_words, Groups, Lists),
    msort(Lists, Ordered),
    forall(member(L, Ordered),
           ( atomic_list_concat(L, ' ', Line), writeln(Line) )).

keyed(W, K-A) :-
    atom_string(A, W),
    atom_codes(A, Cs),
    msort(Cs, Ks),
    atom_codes(K, Ks).

group_words(_-Ws, Sorted) :-
    msort(Ws, Sorted).
