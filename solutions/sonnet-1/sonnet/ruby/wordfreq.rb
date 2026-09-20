text = STDIN.read
counts = Hash.new(0)
text.scan(/[A-Za-z]+/).each do |word|
  counts[word.downcase] += 1
end

counts.sort_by { |word, count| [-count, word] }.each do |word, count|
  puts "#{word} #{count}"
end
