:- table lcs/4.

main :-
    read_line_to_string(user_input, S1),
    read_line_to_string(user_input, S2),
    atom_string(A1, S1),
    atom_string(A2, S2),
    atom_length(A1, Len1),
    atom_length(A2, Len2),
    lcs(A1, A2, Len1, Len2, Result),
    write(Result),
    nl.

% Base cases: if either string is empty, LCS length is 0
lcs(_, _, 0, _, 0).
lcs(_, _, _, 0, 0).

% Recursive case
lcs(S1, S2, I, J, Result) :-
    I > 0, J > 0,
    I1 is I - 1,
    J1 is J - 1,
    sub_atom(S1, I1, 1, _, C1),
    sub_atom(S2, J1, 1, _, C2),
    (C1 = C2 ->
        % Characters match: add 1 to LCS of remaining substrings
        lcs(S1, S2, I1, J1, Res0),
        Result is Res0 + 1
    ;
        % Characters don't match: take max of two options
        lcs(S1, S2, I1, J, Res1),
        lcs(S1, S2, I, J1, Res2),
        (Res1 >= Res2 -> Result = Res1 ; Result = Res2)
    ).
