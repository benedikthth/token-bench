use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut iter = input.split_ascii_whitespace().map(|x| x.parse::<i64>().unwrap());

    let r = iter.next().unwrap() as usize;
    let c = iter.next().unwrap() as usize;

    let mut grid = vec![vec![0i64; c]; r];
    for i in 0..r {
        for j in 0..c {
            grid[i][j] = iter.next().unwrap();
        }
    }

    let mut out = String::new();
    for j in 0..c {
        let mut row: Vec<String> = Vec::with_capacity(r);
        for i in 0..r {
            row.push(grid[i][j].to_string());
        }
        out.push_str(&row.join(" "));
        out.push('\n');
    }

    io::stdout().write_all(out.as_bytes()).unwrap();
}
