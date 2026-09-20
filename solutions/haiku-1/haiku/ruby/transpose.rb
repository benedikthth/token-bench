# Read dimensions
r, c = gets.split.map(&:to_i)

# Read the matrix
matrix = []
r.times do
  row = gets.split.map(&:to_i)
  matrix << row
end

# Transpose and output
matrix.transpose.each do |row|
  puts row.join(' ')
end
