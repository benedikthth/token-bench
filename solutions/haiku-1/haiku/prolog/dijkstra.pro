:- dynamic edge/3.

main :-
    read_line_to_codes(user_input, Line1),
    parse_ints(Line1, [N, M]),
    read_edges(M),
    read_line_to_codes(user_input, LineS),
    parse_ints(LineS, [S, T]),
    solve(N, S, T).

read_edges(0) :- !.
read_edges(M) :-
    M > 0,
    read_line_to_codes(user_input, Line),
    parse_ints(Line, [U, V, W]),
    assertz(edge(U, V, W)),
    assertz(edge(V, W, U)),
    M1 is M - 1,
    read_edges(M1).

parse_ints(Line, Ints) :-
    atom_codes(Atom, Line),
    atomic_list_concat(Parts, ' ', Atom),
    maplist(atom_number, Parts, Ints).

solve(N, S, T) :-
    (S = T ->
        write(0)
    ;
        (dijkstra(N, S, T, Dist) ->
            write(Dist)
        ;
            write(-1)
        )
    ),
    nl.

dijkstra(N, S, T, Dist) :-
    create_dist_map(0, N, S, DistMap),
    dijkstra_loop([(0, S)], [], DistMap, T, Dist).

create_dist_map(N, N, _, []) :- !.
create_dist_map(I, N, S, [dist(I, D)|Rest]) :-
    (I = S -> D = 0 ; D = 999999999),
    I1 is I + 1,
    create_dist_map(I1, N, S, Rest).

get_dist([], _, 999999999) :- !.
get_dist([dist(Node, D)|_], Node, D) :- !.
get_dist([_|Rest], Node, D) :- get_dist(Rest, Node, D).

set_dist([], _, _, []) :- !.
set_dist([dist(Node, _)|Rest], Node, NewD, [dist(Node, NewD)|Rest]) :- !.
set_dist([D|Rest], Node, NewD, [D|Result]) :-
    set_dist(Rest, Node, NewD, Result).

dijkstra_loop([], _, _, _, -1) :- !.
dijkstra_loop([(D, U)|_], _, _, U, D) :- !.
dijkstra_loop([(D, U)|PQ], Visited, DistMap, T, Result) :-
    member(U, Visited), !,
    dijkstra_loop(PQ, Visited, DistMap, T, Result).
dijkstra_loop([(D, U)|PQ], Visited, DistMap, T, Result) :-
    findall(edge(U, V, W), edge(U, V, W), Edges),
    relax_edges(Edges, D, PQ, DistMap, NewPQ, NewDistMap),
    msort(NewPQ, SortedPQ),
    dijkstra_loop(SortedPQ, [U|Visited], NewDistMap, T, Result).

relax_edges([], _, PQ, DM, PQ, DM).
relax_edges([edge(_, V, W)|Rest], D, PQ, DM, NewPQ, NewDM) :-
    relax_edges(Rest, D, PQ, DM, TmpPQ, TmpDM),
    NewD is D + W,
    get_dist(TmpDM, V, OldD),
    (NewD < OldD ->
        set_dist(TmpDM, V, NewD, TmpDM1),
        NewPQ = [(NewD, V)|TmpPQ],
        NewDM = TmpDM1
    ;
        NewPQ = TmpPQ,
        NewDM = TmpDM
    ).
