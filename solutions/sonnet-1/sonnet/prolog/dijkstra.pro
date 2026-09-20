:- initialization(main).

main :-
    read_string(user_input, _, Str),
    split_string(Str, " \t\n\r", " \t\n\r", Parts0),
    exclude(==(""), Parts0, Parts),
    maplist(number_string, Nums, Parts),
    Nums = [N, M | Rest1],
    EdgeCount is M * 3,
    length(EdgeNums, EdgeCount),
    append(EdgeNums, [S, T], Rest1),
    edges_from_triples(EdgeNums, Edges),
    build_adj(N, Edges, Adj),
    inf(Inf),
    length(Dists0, N),
    maplist(=(Inf), Dists0),
    replace_nth0(S, Dists0, 0, Dists1),
    ( N > 0 -> NLast is N - 1, numlist(0, NLast, Unvisited) ; Unvisited = [] ),
    loop(Adj, Unvisited, Dists1, FinalDists),
    nth0(T, FinalDists, DT),
    ( DT >= Inf -> Ans = -1 ; Ans = DT ),
    format("~w~n", [Ans]).

inf(999999999).

% Build a pair of directed edges (as node-adjacency entries) from flat triples.
edges_from_triples([], []).
edges_from_triples([U, V, W | Rest], [edge(U, V, W), edge(V, U, W) | Edges]) :-
    edges_from_triples(Rest, Edges).

build_adj(N, Edges, Adj) :-
    ( N > 0 -> NLast is N - 1, numlist(0, NLast, Nodes) ; Nodes = [] ),
    maplist(node_adj(Edges), Nodes, Adj).

node_adj(Edges, Node, AdjList) :-
    findall(V - W, member(edge(Node, V, W), Edges), AdjList).

replace_nth0(I, List, Elem, NewList) :-
    nth0(I, List, _, Rest),
    nth0(I, NewList, Elem, Rest).

pick_min(Unvisited, Dists, U, MinD) :-
    findall(D - Nd, (member(Nd, Unvisited), nth0(Nd, Dists, D)), Pairs),
    keysort(Pairs, [MinD - U | _]).

relax(Neighbors, U, Dists, Dists1) :-
    nth0(U, Dists, DU),
    foldl(relax_one(DU), Neighbors, Dists, Dists1).

relax_one(DU, V - W, DistsIn, DistsOut) :-
    nth0(V, DistsIn, DV),
    NewD is DU + W,
    ( NewD < DV -> replace_nth0(V, DistsIn, NewD, DistsOut) ; DistsOut = DistsIn ).

loop(_Adj, [], Dists, Dists).
loop(Adj, Unvisited, Dists, FinalDists) :-
    Unvisited = [_ | _],
    pick_min(Unvisited, Dists, U, _MinD),
    selectchk(U, Unvisited, Unvisited1),
    nth0(U, Adj, Neighbors),
    relax(Neighbors, U, Dists, Dists1),
    loop(Adj, Unvisited1, Dists1, FinalDists).
