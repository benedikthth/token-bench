use std::io::{self, BufRead};
use std::collections::BTreeMap;

fn main() {
    let stdin = io::stdin();
    let reader = stdin.lock();

    // Map from sorted letters to list of words
    let mut groups: BTreeMap<String, Vec<String>> = BTreeMap::new();

    for line in reader.lines() {
        if let Ok(word) = line {
            // Create the key by sorting the letters
            let mut sorted_chars: Vec<char> = word.chars().collect();
            sorted_chars.sort_unstable();
            let key: String = sorted_chars.iter().collect();

            // Add word to the group
            groups.entry(key).or_insert_with(Vec::new).push(word);
        }
    }

    // Sort words within each group and collect into a vector
    let mut sorted_groups: Vec<Vec<String>> = groups
        .into_values()
        .map(|mut group| {
            group.sort_unstable();
            group
        })
        .collect();

    // Sort groups by their first word
    sorted_groups.sort_unstable_by(|a, b| a[0].cmp(&b[0]));

    // Output
    for group in sorted_groups {
        println!("{}", group.join(" "));
    }
}
