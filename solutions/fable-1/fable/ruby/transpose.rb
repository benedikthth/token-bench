data = STDIN.read.split
r = data[0].to_i
c = data[1].to_i
vals = data[2, r * c] || []
out = []
c.times do |j|
  row = Array.new(r) { |i| vals[i * c + j] }
  out << row.join(' ')
end
puts out.join("\n") unless out.empty?
