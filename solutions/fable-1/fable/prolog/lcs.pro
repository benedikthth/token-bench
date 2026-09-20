main :-
    read_line(A),
    read_line(B),
    length(B, M),
    M1 is M + 1,
    length(Row0, M1),
    maplist(=(0), Row0),
    lcs_rows(A, B, Row0, RowN),
    last(RowN, Ans),
    format("~w~n", [Ans]).

read_line(Codes) :-
    read_line_to_codes(user_input, L),
    (   L == end_of_file
    ->  Codes = []
    ;   strip_cr(L, Codes)
    ).

strip_cr(L, Codes) :-
    (   append(Codes, [0'\r], L)
    ->  true
    ;   Codes = L
    ).

lcs_rows([], _, Row, Row).
lcs_rows([C|Cs], B, Prev, Final) :-
    row(C, B, Prev, 0, Rest),
    Next = [0|Rest],
    lcs_rows(Cs, B, Next, Final).

row(_, [], _, _, []).
row(C, [Bc|Bs], [Diag, Up|PrevRest], Left, [Cur|Rest]) :-
    (   Bc == C
    ->  Cur is Diag + 1
    ;   Cur is max(Up, Left)
    ),
    row(C, Bs, [Up|PrevRest], Cur, Rest).
