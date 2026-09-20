use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    // Read R and C
    let first_line = lines.next().unwrap().unwrap();
    let parts: Vec<&str> = first_line.split_whitespace().collect();
    let r: usize = parts[0].parse().unwrap();
    let c: usize = parts[1].parse().unwrap();

    // Read the matrix
    let mut matrix: Vec<Vec<i32>> = Vec::new();
    for _ in 0..r {
        let line = lines.next().unwrap().unwrap();
        let row: Vec<i32> = line.split_whitespace()
            .map(|s| s.parse().unwrap())
            .collect();
        matrix.push(row);
    }

    // Transpose and output
    for j in 0..c {
        let mut output = Vec::new();
        for i in 0..r {
            output.push(matrix[i][j].to_string());
        }
        println!("{}", output.join(" "));
    }
}
