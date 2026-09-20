use std::collections::BinaryHeap;
use std::cmp::Ordering;
use std::io::{self, BufRead};

#[derive(Eq, PartialEq)]
struct State {
    cost: usize,
    node: usize,
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        // Reverse comparison for min-heap
        other.cost.cmp(&self.cost)
            .then_with(|| self.node.cmp(&other.node))
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    // Read N and M
    let first_line = lines.next().unwrap().unwrap();
    let parts: Vec<&str> = first_line.split_whitespace().collect();
    let n: usize = parts[0].parse().unwrap();
    let m: usize = parts[1].parse().unwrap();

    // Build adjacency list
    let mut graph: Vec<Vec<(usize, usize)>> = vec![Vec::new(); n];

    for _ in 0..m {
        let line = lines.next().unwrap().unwrap();
        let parts: Vec<&str> = line.split_whitespace().collect();
        let u: usize = parts[0].parse().unwrap();
        let v: usize = parts[1].parse().unwrap();
        let w: usize = parts[2].parse().unwrap();

        graph[u].push((v, w));
        graph[v].push((u, w));
    }

    // Read s and t
    let last_line = lines.next().unwrap().unwrap();
    let parts: Vec<&str> = last_line.split_whitespace().collect();
    let s: usize = parts[0].parse().unwrap();
    let t: usize = parts[1].parse().unwrap();

    // Handle special case where s equals t
    if s == t {
        println!("0");
        return;
    }

    // Dijkstra's algorithm
    let mut distances = vec![usize::MAX; n];
    let mut heap = BinaryHeap::new();

    distances[s] = 0;
    heap.push(State { cost: 0, node: s });

    while let Some(State { cost, node }) = heap.pop() {
        // If we've already found a shorter path, skip this state
        if cost > distances[node] {
            continue;
        }

        // If we reached the target, output and exit
        if node == t {
            println!("{}", cost);
            return;
        }

        // Explore neighbors
        for &(next_node, weight) in &graph[node] {
            let next_cost = cost + weight;

            if next_cost < distances[next_node] {
                distances[next_node] = next_cost;
                heap.push(State { cost: next_cost, node: next_node });
            }
        }
    }

    // No path found
    println!("-1");
}
