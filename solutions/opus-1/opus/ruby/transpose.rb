tokens = $stdin.read.split
r = tokens[0].to_i
c = tokens[1].to_i
vals = tokens[2, r * c] || []
out = []
c.times do |j|
  out << (0...r).map { |i| vals[i * c + j] }.join(" ")
end
print out.map { |l| l + "\n" }.join
