main :-
    read_all_lines(Lines),
    forall(member(Line, Lines),
           ( is_balanced(Line) -> writeln(yes) ; writeln(no) )
    ).

read_all_lines(Lines) :-
    read_line_to_string(user_input, Line),
    ( Line == end_of_file
    -> Lines = []
    ;  read_all_lines(Rest), Lines = [Line|Rest]
    ).

is_balanced(Line) :-
    string_chars(Line, Chars),
    balanced(Chars, []).

balanced([], []).
balanced([C|Cs], Stack) :-
    (   match(C, Close)
    ->  balanced(Cs, [Close|Stack])
    ;   ( C == ')' ; C == ']' ; C == '}' )
    ->  Stack = [C|Rest],
        balanced(Cs, Rest)
    ;   balanced(Cs, Stack)
    ).

match('(', ')').
match('[', ']').
match('{', '}').
