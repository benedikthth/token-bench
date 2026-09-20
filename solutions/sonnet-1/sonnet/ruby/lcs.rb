a = gets.to_s.chomp
b = gets.to_s.chomp

n = a.length
m = b.length

prev = Array.new(m + 1, 0)
curr = Array.new(m + 1, 0)

(1..n).each do |i|
  ca = a[i - 1]
  (1..m).each do |j|
    if ca == b[j - 1]
      curr[j] = prev[j - 1] + 1
    else
      curr[j] = prev[j] > curr[j - 1] ? prev[j] : curr[j - 1]
    end
  end
  prev, curr = curr, prev
end

puts prev[m]
