VALUES = [
  [1000, "M"], [900, "CM"], [500, "D"], [400, "CD"],
  [100, "C"], [90, "XC"], [50, "L"], [40, "XL"],
  [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]
]

def to_roman(n)
  result = ""
  VALUES.each do |value, symbol|
    while n >= value
      result << symbol
      n -= value
    end
  end
  result
end

STDIN.each_line do |line|
  line = line.strip
  next if line.empty?
  puts to_roman(line.to_i)
end
