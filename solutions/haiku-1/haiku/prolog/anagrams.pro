main :-
    read_all_words(Words),
    create_canonical_groups(Words, Groups),
    print_groups(Groups).

read_all_words(Words) :-
    read_all_lines(Lines),
    (Lines = [] -> Words = [] ; Words = Lines).

read_all_lines([Word | Rest]) :-
    read_line_to_codes(user_input, Codes),
    Codes \= end_of_file,
    !,
    atom_codes(Word, Codes),
    read_all_lines(Rest).
read_all_lines([]).

create_canonical_groups(Words, SortedGroups) :-
    % Create (canonical, word) pairs where canonical is sorted letters
    maplist(canonical_pair, Words, Pairs),
    % Sort pairs to group by canonical form
    sort(Pairs, SortedPairs),
    % Group by canonical form
    group_by_first_element(SortedPairs, GroupedByCanonical),
    % Sort words within each group and pair with first word
    maplist(sort_and_pair, GroupedByCanonical, FirstWordPairs),
    % Sort groups by their first word
    keysort(FirstWordPairs, SortedByFirstWord),
    % Extract the sorted groups
    maplist(extract_group, SortedByFirstWord, SortedGroups).

% canonical_pair(+Word, -Canonical-Word)
% Creates a pair where Canonical is the word with sorted letters
canonical_pair(Word, Canonical-Word) :-
    atom_codes(Word, Codes),
    sort(Codes, Sorted),
    atom_codes(Canonical, Sorted).

% group_by_first_element(+Pairs, -GroupedPairs)
% Groups Key-Value pairs by Key, collecting all Values for each Key
group_by_first_element([], []).
group_by_first_element([K-V | Rest], [K-[V|Vs]|Groups]) :-
    partition(match_key(K), Rest, Same, Different),
    maplist(get_value, Same, Vs),
    group_by_first_element(Different, Groups).

match_key(K, K-_).
get_value(_-V, V).

% sort_and_pair(+Canonical-Words, -FirstWord-SortedWords)
% Sorts words within a group and pairs with the first word
sort_and_pair(Canonical-Words, FirstWord-SortedWords) :-
    sort(Words, SortedWords),
    SortedWords = [FirstWord | _].

extract_group(_-Group, Group).

% print_groups(+Groups)
% Prints each group on one line with space-separated words
print_groups([]).
print_groups([Group | Groups]) :-
    atomic_list_concat(Group, ' ', Line),
    write(Line), nl,
    print_groups(Groups).
