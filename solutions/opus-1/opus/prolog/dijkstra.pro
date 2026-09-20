:- use_module(library(heaps)).
:- use_module(library(assoc)).

:- dynamic edge/3.

main :-
    read_string(user_input, _, Str),
    split_string(Str, " \t\r\n", " \t\r\n", Parts0),
    exclude(==(""), Parts0, Parts),
    maplist(number_string, Nums, Parts),
    Nums = [_N, M | Rest],
    load_edges(M, Rest, [S, T | _]),
    (   S =:= T
    ->  D = 0
    ;   dijkstra(S, T, D)
    ),
    format("~w~n", [D]).

load_edges(0, Rest, Rest) :- !.
load_edges(K, [U, V, W | Rest], Out) :-
    assertz(edge(U, V, W)),
    assertz(edge(V, U, W)),
    K1 is K - 1,
    load_edges(K1, Rest, Out).

dijkstra(S, T, D) :-
    singleton_heap(H, 0, S),
    empty_assoc(Done),
    loop(H, Done, T, D).

loop(H, Done, T, D) :-
    (   get_from_heap(H, Du, U, H1)
    ->  (   get_assoc(U, Done, _)
        ->  loop(H1, Done, T, D)
        ;   U == T
        ->  D = Du
        ;   put_assoc(U, Done, Du, Done1),
            findall(Dv-V, (edge(U, V, W), \+ get_assoc(V, Done1, _), Dv is Du + W), Ns),
            foldl(push, Ns, H1, H2),
            loop(H2, Done1, T, D)
        )
    ;   D = -1
    ).

push(P-V, H0, H) :- add_to_heap(H0, P, V, H).
