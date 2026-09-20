use std::collections::HashMap;
use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();

    let mut groups: HashMap<String, Vec<String>> = HashMap::new();

    for line in input.lines() {
        let word = line.trim();
        if word.is_empty() {
            continue;
        }
        let mut chars: Vec<char> = word.chars().collect();
        chars.sort_unstable();
        let key: String = chars.into_iter().collect();
        groups.entry(key).or_insert_with(Vec::new).push(word.to_string());
    }

    let mut group_list: Vec<Vec<String>> = Vec::new();
    for (_, mut words) in groups {
        words.sort();
        group_list.push(words);
    }

    group_list.sort_by(|a, b| a[0].cmp(&b[0]));

    let stdout = io::stdout();
    let mut out = stdout.lock();
    for group in group_list {
        let line = group.join(" ");
        writeln!(out, "{}", line).unwrap();
    }
}
