PAIRS = [
  [1000, "M"], [900, "CM"], [500, "D"], [400, "CD"],
  [100, "C"], [90, "XC"], [50, "L"], [40, "XL"],
  [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]
].freeze

def to_roman(n)
  out = +""
  PAIRS.each do |value, sym|
    while n >= value
      out << sym
      n -= value
    end
  end
  out
end

$stdin.each_line do |line|
  s = line.strip
  next if s.empty?
  puts to_roman(s.to_i)
end
