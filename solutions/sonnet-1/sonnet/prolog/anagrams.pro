main :-
    read_all_words(Words),
    ( Words == []
    -> true
    ;  key_pairs(Words, Pairs),
       keysort(Pairs, Sorted),
       group_pairs_by_key(Sorted, Grouped),
       pairs_values(Grouped, Groups0),
       maplist(msort, Groups0, Groups1),
       maplist(first_key_pair, Groups1, FirstPairs),
       keysort(FirstPairs, OrderedPairs),
       pairs_values(OrderedPairs, OrderedGroups),
       maplist(print_group, OrderedGroups)
    ).

read_all_words(Words) :-
    read_line_to_string(user_input, Line),
    ( Line == end_of_file
    -> Words = []
    ;  ( Line == ""
       -> read_all_words(Words)
       ;  atom_string(Word, Line),
          read_all_words(Rest),
          Words = [Word|Rest]
       )
    ).

key_pairs([], []).
key_pairs([Word|Words], [Key-Word|Pairs]) :-
    atom_chars(Word, Chars),
    msort(Chars, SortedChars),
    atom_chars(Key, SortedChars),
    key_pairs(Words, Pairs).

first_key_pair(Group, First-Group) :-
    Group = [First|_].

print_group(Words) :-
    atomic_list_concat(Words, ' ', Line),
    writeln(Line).
