main :-
    read_words(Words),
    findall(Key-W, (member(W, Words), atom_chars(W, Cs), msort(Cs, Sorted), atom_chars(Key, Sorted)), Pairs),
    msort(Pairs, SortedPairs),
    group_pairs(SortedPairs, Groups),
    msort(Groups, SortedGroups),
    forall(member(G, SortedGroups), (atomic_list_concat(G, ' ', Line), writeln(Line))).

read_words(Words) :-
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  Words = []
    ;   normalize_space(atom(W), Line),
        (   W == ''
        ->  Words = Rest
        ;   Words = [W|Rest]
        ),
        read_words(Rest)
    ).

group_pairs([], []).
group_pairs([K-W|Rest], [[W|Ws]|Groups]) :-
    take_key(K, Rest, Ws, Remaining),
    group_pairs(Remaining, Groups).

take_key(K, [K-W|Rest], [W|Ws], Remaining) :- !,
    take_key(K, Rest, Ws, Remaining).
take_key(_, Rest, [], Rest).
