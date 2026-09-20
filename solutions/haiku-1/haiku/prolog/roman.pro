% Roman numeral value-symbol pairs in descending order
roman_pairs([
    (1000, 'M'),
    (900, 'CM'),
    (500, 'D'),
    (400, 'CD'),
    (100, 'C'),
    (90, 'XC'),
    (50, 'L'),
    (40, 'XL'),
    (10, 'X'),
    (9, 'IX'),
    (5, 'V'),
    (4, 'IV'),
    (1, 'I')
]).

% Convert integer to Roman numeral
int_to_roman(N, Roman) :-
    roman_pairs(Pairs),
    convert(N, Pairs, Roman).

% Helper predicate to convert using the pairs list
% Base cases: when N reaches 0 or pairs list is exhausted
convert(0, _, '') :- !.
convert(_, [], '') :- !.
% Recursive case: if N >= Value, use Symbol and continue with remainder
convert(N, [(Value, Symbol)|Rest], Roman) :-
    (   N >= Value
    ->  N1 is N - Value,
        convert(N1, [(Value, Symbol)|Rest], Roman1),
        atom_concat(Symbol, Roman1, Roman)
    ;   convert(N, Rest, Roman)
    ).

% Read a number from a line of text
read_number(N) :-
    read_line_to_codes(user_input, Codes),
    Codes \= end_of_file,
    atom_codes(A, Codes),
    atom_number(A, N).

% Read integers from input and convert each to Roman numeral
process_input :-
    (   read_number(N)
    ->  int_to_roman(N, Roman),
        write(Roman),
        nl,
        process_input
    ;   true
    ).

% Main entry point
main :- process_input.
