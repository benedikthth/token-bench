:- dynamic word_count/2.

main :-
    read_string(user_input, _, String),
    string_lower(String, Lower),
    extract_words_from_string(Lower, Words),
    count_words(Words),
    findall(Word-Count, word_count(Word, Count), WordCounts),
    predsort(compare_word_counts, WordCounts, Sorted),
    output_results(Sorted).

% Extract words from a string
extract_words_from_string(String, Words) :-
    atom_string(Atom, String),
    atom_codes(Atom, Codes),
    collect_words(Codes, [], [], Words).

% collect_words(RemainingCodes, CurrentWordCodes, WordsSoFar, FinalWords)
collect_words([], [], WordsSoFar, Words) :-
    !,
    reverse(WordsSoFar, Words).
collect_words([], CurrentWord, WordsSoFar, Words) :-
    CurrentWord \= [],
    !,
    reverse(CurrentWord, ReversedCodes),
    atom_codes(Word, ReversedCodes),
    reverse([Word|WordsSoFar], Words).
collect_words([Code|Rest], CurrentWord, WordsSoFar, Words) :-
    (   Code >= 97, Code =< 122  % lowercase letter (a-z)
    ->  collect_words(Rest, [Code|CurrentWord], WordsSoFar, Words)
    ;   (   CurrentWord = []
        ->  collect_words(Rest, [], WordsSoFar, Words)
        ;   reverse(CurrentWord, ReversedCodes),
            atom_codes(Word, ReversedCodes),
            collect_words(Rest, [], [Word|WordsSoFar], Words)
        )
    ).

count_words([]).
count_words([Word|Rest]) :-
    (   word_count(Word, Count)
    ->  NewCount is Count + 1,
        retract(word_count(Word, Count)),
        assertz(word_count(Word, NewCount))
    ;   assertz(word_count(Word, 1))
    ),
    count_words(Rest).

compare_word_counts(Order, Word1-Count1, Word2-Count2) :-
    (   Count1 > Count2
    ->  Order = (<)
    ;   Count1 < Count2
    ->  Order = (>)
    ;   compare(Order, Word1, Word2)
    ).

output_results([]).
output_results([Word-Count|Rest]) :-
    format('~w ~w~n', [Word, Count]),
    output_results(Rest).
