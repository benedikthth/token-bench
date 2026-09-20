:- use_module(library(heaps)).
:- use_module(library(lists)).

:- dynamic edge/3.
:- dynamic visited/1.

main :-
    read_string(user_input, _, Str),
    split_string(Str, " \t\r\n", " \t\r\n", Toks0),
    exclude(==(""), Toks0, Toks),
    maplist(number_string, Nums, Toks),
    Nums = [_N, M | Rest],
    EdgeCount is 3 * M,
    length(EdgeNums, EdgeCount),
    append(EdgeNums, [S, T | _], Rest),
    add_edges(EdgeNums),
    dijkstra(S, T, Ans),
    format("~w~n", [Ans]).

add_edges([]).
add_edges([U, V, W | Rest]) :-
    assertz(edge(U, V, W)),
    assertz(edge(V, U, W)),
    add_edges(Rest).

dijkstra(S, T, Ans) :-
    empty_heap(H0),
    add_to_heap(H0, 0, S, H1),
    loop(H1, T, Ans).

loop(H, T, Ans) :-
    (   get_from_heap(H, D, U, H1)
    ->  (   U =:= T
        ->  Ans = D
        ;   visited(U)
        ->  loop(H1, T, Ans)
        ;   assertz(visited(U)),
            findall(ND-V, (edge(U, V, W), \+ visited(V), ND is D + W), Ns),
            push_all(Ns, H1, H2),
            loop(H2, T, Ans)
        )
    ;   Ans = -1
    ).

push_all([], H, H).
push_all([P-V | Rest], H0, H) :-
    add_to_heap(H0, P, V, H1),
    push_all(Rest, H1, H).
