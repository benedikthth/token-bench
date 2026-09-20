a = ($stdin.gets || "").chomp.delete("\r")
b = ($stdin.gets || "").chomp.delete("\r")
if a.empty? || b.empty?
  puts 0
  exit
end
m = a.length
mask = (1 << m) - 1
masks = Hash.new(0)
a.each_char.with_index { |c, i| masks[c] |= 1 << i }
v = mask
b.each_char do |c|
  u = v & masks[c]
  v = ((v + u) | (v - u)) & mask
end
puts m - v.to_s(2).count("1")
