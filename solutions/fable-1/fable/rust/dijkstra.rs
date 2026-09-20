use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut it = input.split_ascii_whitespace().map(|x| x.parse::<i64>().unwrap());

    let n = match it.next() {
        Some(v) => v as usize,
        None => return,
    };
    let m = it.next().unwrap_or(0) as usize;

    let mut adj: Vec<Vec<(usize, u64)>> = vec![Vec::new(); n];
    for _ in 0..m {
        let u = it.next().unwrap() as usize;
        let v = it.next().unwrap() as usize;
        let w = it.next().unwrap() as u64;
        if u < n && v < n {
            adj[u].push((v, w));
            adj[v].push((u, w));
        }
    }

    let s = it.next().unwrap_or(0) as usize;
    let t = it.next().unwrap_or(0) as usize;

    let out = io::stdout();
    let mut out = out.lock();

    if s == t {
        writeln!(out, "0").unwrap();
        return;
    }
    if s >= n || t >= n {
        writeln!(out, "-1").unwrap();
        return;
    }

    let mut dist = vec![u64::MAX; n];
    dist[s] = 0;
    let mut heap = BinaryHeap::new();
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
