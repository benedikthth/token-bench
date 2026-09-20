# Read all input
input = STDIN.read

# Convert to lowercase for case-insensitive comparison
input = input.downcase

# Extract words (maximal runs of ASCII letters) and count them
word_count = {}
input.scan(/[a-z]+/) do |word|
  word_count[word] = (word_count[word] || 0) + 1
end

# Sort: by count descending, then by word ascending
sorted = word_count.sort_by { |word, count| [-count, word] }

# Output
sorted.each do |word, count|
  puts "#{word} #{count}"
end
