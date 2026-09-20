r, c = gets.split.map(&:to_i)
matrix = Array.new(r) { gets.split.map(&:to_i) }

result = Array.new(c) { |j| Array.new(r) { |i| matrix[i][j] } }

puts result.map { |row| row.join(' ') }
