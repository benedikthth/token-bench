use std::io::{self, Read};
use std::collections::HashMap;

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();

    let mut word_counts: HashMap<String, usize> = HashMap::new();

    let mut current_word = String::new();

    for ch in input.chars() {
        if ch.is_ascii_alphabetic() {
            current_word.push(ch.to_ascii_lowercase());
        } else {
            if !current_word.is_empty() {
                *word_counts.entry(current_word.clone()).or_insert(0) += 1;
                current_word.clear();
            }
        }
    }

    // Don't forget the last word if input doesn't end with non-letter
    if !current_word.is_empty() {
        *word_counts.entry(current_word).or_insert(0) += 1;
    }

    // Sort by count descending, then by word ascending
    let mut words: Vec<_> = word_counts.into_iter().collect();
    words.sort_by(|a, b| {
        match b.1.cmp(&a.1) {
            std::cmp::Ordering::Equal => a.0.cmp(&b.0),
            other => other,
        }
    });

    // Output
    for (word, count) in words {
        println!("{} {}", word, count);
    }
}
