use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut it = input.split_ascii_whitespace().map(|x| x.parse::<u64>().unwrap());
    let n = it.next().unwrap_or(0) as usize;
    let m = it.next().unwrap_or(0) as usize;
    let mut adj: Vec<Vec<(usize, u64)>> = vec![Vec::new(); n];
    for _ in 0..m {
        let u = it.next().unwrap() as usize;
        let v = it.next().unwrap() as usize;
        let w = it.next().unwrap();
        adj[u].push((v, w));
        adj[v].push((u, w));
    }
    let s = it.next().unwrap() as usize;
    let t = it.next().unwrap() as usize;

    let out = io::stdout();
    let mut out = out.lock();
    if s == t {
        writeln!(out, "0").unwrap();
        return;
    }

    let mut dist = vec![u64::MAX; n];
    let mut heap = BinaryHeap::new();
    dist[s] = 0;
    heap.push(Reverse((0u64, s)));
    while let Some(Reverse((d, u))) = heap.pop() {
        if d > dist[u] {
            continue;
        }
        if u == t {
            break;
        }
        for &(v, w) in &adj[u] {
            let nd = d + w;
            if nd < dist[v] {
                dist[v] = nd;
                heap.push(Reverse((nd, v)));
            }
        }
    }

    if dist[t] == u64::MAX {
        writeln!(out, "-1").unwrap();
    } else {
        writeln!(out, "{}", dist[t]).unwrap();
    }
}
