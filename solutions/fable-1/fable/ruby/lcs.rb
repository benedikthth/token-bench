a = ($stdin.gets || "").chomp
b = ($stdin.gets || "").chomp

# Make b the shorter string to keep the rolling row small.
a, b = b, a if b.length > a.length

m = b.length
if m == 0
  puts 0
  exit
end

bb = b.bytes
prev = Array.new(m + 1, 0)
cur = Array.new(m + 1, 0)

a.each_byte do |ca|
  j = 0
  while j < m
    if ca == bb[j]
      cur[j + 1] = prev[j] + 1
    else
      p1 = prev[j + 1]
      c0 = cur[j]
      cur[j + 1] = p1 > c0 ? p1 : c0
    end
    j += 1
  end
  prev, cur = cur, prev
end

puts prev[m]
