main :-
    read_line_to_codes(user_input, Codes),
    rle_codes(Codes, Result),
    atom_codes(Output, Result),
    write(Output), nl.

rle_codes([], []) :- !.
rle_codes([First|Rest], Result) :-
    count_run(First, Rest, Count, Remaining),
    number_codes(Count, CountCodes),
    append([First], CountCodes, Run),
    rle_codes(Remaining, RestResult),
    append(Run, RestResult, Result).

count_run(Char, Rest, Count, Remaining) :-
    count_run_acc(Char, Rest, 1, Count, Remaining).

count_run_acc(_, [], Count, Count, []) :- !.
count_run_acc(Char, [Next|Rest], Acc, Count, Remaining) :-
    (Char =:= Next ->
        NewAcc is Acc + 1,
        count_run_acc(Char, Rest, NewAcc, Count, Remaining)
    ;
        Count = Acc,
        Remaining = [Next|Rest]
    ).
