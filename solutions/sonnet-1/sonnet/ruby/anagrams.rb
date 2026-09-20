words = STDIN.read.split("\n").map(&:strip).reject(&:empty?)

groups = Hash.new { |h, k| h[k] = [] }
words.each do |word|
  key = word.chars.sort.join
  groups[key] << word
end

lines = groups.values.map { |g| g.sort }
lines.sort_by! { |g| g.first }

puts lines.map { |g| g.join(" ") }
