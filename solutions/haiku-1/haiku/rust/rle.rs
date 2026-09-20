use std::io;

fn main() {
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();

    // Remove the newline at the end
    let input = input.trim_end();

    let mut result = String::new();
    let mut chars = input.chars().peekable();

    while let Some(ch) = chars.next() {
        let mut count = 1;
        while let Some(&next_ch) = chars.peek() {
            if next_ch == ch {
                count += 1;
                chars.next();
            } else {
                break;
            }
        }
        result.push(ch);
        result.push_str(&count.to_string());
    }

    println!("{}", result);
}
