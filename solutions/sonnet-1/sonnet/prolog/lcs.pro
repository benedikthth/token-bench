main :-
    read_input_line(Line1),
    read_input_line(Line2),
    string_codes(Line1, Codes1),
    string_codes(Line2, Codes2),
    length(Codes1, N),
    length(Codes2, M),
    make_char_array(Codes1, N, ArrA),
    make_char_array(Codes2, M, ArrB),
    make_zero_row(M, Prev0),
    lcs_rows(1, N, M, ArrA, ArrB, Prev0, Result),
    format("~w~n", [Result]).

% Read a line of input, stripping any trailing carriage return.
% Treat end of file as an empty line.
read_input_line(Line) :-
    read_line_to_string(user_input, Raw),
    ( Raw == end_of_file
    -> Line = ""
    ;  ( string_concat(Stripped, "\r", Raw)
       -> Line = Stripped
       ;  Line = Raw
       )
    ).

% make_char_array(+Codes, +N, -Arr)
% Arr is a compound term of arity N with Arr[i] (1-based) = i-th code.
make_char_array(Codes, N, Arr) :-
    functor(Arr, chars, N),
    fill_chars(Codes, 1, Arr).

fill_chars([], _, _).
fill_chars([C|Cs], I, Arr) :-
    nb_setarg(I, Arr, C),
    I1 is I + 1,
    fill_chars(Cs, I1, Arr).

% make_zero_row(+Size, -Row)
% Row is a compound term of arity Size+1, all args set to 0.
% Row[j] (0-based, j = 0..Size) is stored at arg(j+1, Row).
make_zero_row(Size, Row) :-
    Arity is Size + 1,
    functor(Row, row, Arity),
    zero_fill(Row, 1, Arity).

zero_fill(Row, I, Arity) :-
    ( I > Arity
    -> true
    ;  nb_setarg(I, Row, 0),
       I1 is I + 1,
       zero_fill(Row, I1, Arity)
    ).

% lcs_rows(+I, +N, +M, +ArrA, +ArrB, +Prev, -Result)
% Computes the DP row by row; Prev is the row for i-1, produces Result
% as the final value Row[N][M] once I > N.
lcs_rows(I, N, M, _, _, Prev, Result) :-
    I > N,
    !,
    LastIdx is M + 1,
    arg(LastIdx, Prev, Result).
lcs_rows(I, N, M, ArrA, ArrB, Prev, Result) :-
    I =< N,
    make_zero_row(M, Cur),
    arg(I, ArrA, Ai),
    lcs_cols(1, M, Ai, ArrB, Prev, Cur),
    I1 is I + 1,
    lcs_rows(I1, N, M, ArrA, ArrB, Cur, Result).

% lcs_cols(+J, +M, +Ai, +ArrB, +Prev, +Cur)
% Fills Cur[1..M] given the character Ai and the previous row Prev.
lcs_cols(J, M, _, _, _, _) :-
    J > M,
    !.
lcs_cols(J, M, Ai, ArrB, Prev, Cur) :-
    J =< M,
    arg(J, ArrB, Bj),
    ( Ai =:= Bj
    -> arg(J, Prev, Diag),          % Prev[J-1]
       Val is Diag + 1
    ;  JPlus1 is J + 1,
       arg(JPlus1, Prev, Up),       % Prev[J]
       arg(J, Cur, Left),           % Cur[J-1]
       Val is max(Up, Left)
    ),
    JPlus1b is J + 1,
    nb_setarg(JPlus1b, Cur, Val),
    J1 is J + 1,
    lcs_cols(J1, M, Ai, ArrB, Prev, Cur).
