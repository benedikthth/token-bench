main :-
    process_lines.

process_lines :-
    read_line_to_codes(user_input, Line),
    Line \= end_of_file,
    !,
    (balanced(Line, []) -> write('yes') ; write('no')),
    nl,
    process_lines.
process_lines.

balanced([], []) :- !.
balanced([C|Rest], Stack) :-
    opening(C),
    !,
    balanced(Rest, [C|Stack]).
balanced([C|Rest], [H|Stack]) :-
    closing(C),
    matching(H, C),
    !,
    balanced(Rest, Stack).

opening(40).  % '('
opening(91).  % '['
opening(123). % '{'

closing(41).  % ')'
closing(93).  % ']'
closing(125). % '}'

matching(40, 41).   % '(' matches ')'
matching(91, 93).   % '[' matches ']'
matching(123, 125). % '{' matches '}'
