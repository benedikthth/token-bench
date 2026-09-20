use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::io::{self, Read, Write};

struct State {
    cost: u64,
    node: usize,
}

impl Eq for State {}

impl PartialEq for State {
    fn eq(&self, other: &Self) -> bool {
        self.cost == other.cost
    }
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        other.cost.cmp(&self.cost)
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut it = input.split_ascii_whitespace().map(|x| x.parse::<i64>().unwrap());

    let n = it.next().unwrap() as usize;
    let m = it.next().unwrap() as usize;

    let mut adj: Vec<Vec<(usize, u64)>> = vec![Vec::new(); n];

    for _ in 0..m {
        let u = it.next().unwrap() as usize;
        let v = it.next().unwrap() as usize;
        let w = it.next().unwrap() as u64;
        adj[u].push((v, w));
        adj[v].push((u, w));
    }

    let s = it.next().unwrap() as usize;
    let t = it.next().unwrap() as usize;

    let mut dist = vec![u64::MAX; n];
    dist[s] = 0;
    let mut heap = BinaryHeap::new();
    heap.push(State { cost: 0, node: s });

    while let Some(State { cost, node }) = heap.pop() {
        if cost > dist[node] {
            continue;
        }
        if node == t {
            break;
        }
        for &(next, w) in &adj[node] {
            let new_cost = cost + w;
            if new_cost < dist[next] {
                dist[next] = new_cost;
                heap.push(State { cost: new_cost, node: next });
            }
        }
    }

    let out = if dist[t] == u64::MAX {
        "-1".to_string()
    } else {
        dist[t].to_string()
    };

    let stdout = io::stdout();
    let mut handle = stdout.lock();
    writeln!(handle, "{}", out).unwrap();
}
