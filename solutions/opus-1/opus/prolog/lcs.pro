% Bit-parallel LCS (Hyyro) using unbounded integers.

read_l(S) :-
    read_line_to_string(user_input, L),
    (   L == end_of_file
    ->  S = ""
    ;   split_string(L, "", "\r\n \t", [S])
    ).

build_masks(Codes, Assoc) :-
    empty_assoc(A0),
    build_masks(Codes, 0, A0, Assoc).

build_masks([], _, A, A).
build_masks([C|Cs], I, A0, A) :-
    (   get_assoc(C, A0, M0) -> true ; M0 = 0 ),
    M1 is M0 \/ (1 << I),
    put_assoc(C, A0, M1, A1),
    I1 is I + 1,
    build_masks(Cs, I1, A1, A).

run([], _, _, V, V).
run([C|Cs], As, Mask, V0, V) :-
    (   get_assoc(C, As, M)
    ->  U is V0 /\ M,
        V1 is ((V0 + U) \/ (V0 - U)) /\ Mask
    ;   V1 = V0
    ),
    run(Cs, As, Mask, V1, V).

main :-
    read_l(A),
    read_l(B),
    string_codes(A, CA),
    string_codes(B, CB),
    length(CA, N),
    Mask is (1 << N) - 1,
    build_masks(CA, As),
    run(CB, As, Mask, Mask, V),
    R is N - popcount(V),
    format("~d~n", [R]).
