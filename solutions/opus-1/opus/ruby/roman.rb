VALS = [[1000, "M"], [900, "CM"], [500, "D"], [400, "CD"], [100, "C"], [90, "XC"],
        [50, "L"], [40, "XL"], [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]]
out = []
STDIN.each_line do |line|
  s = line.strip
  next if s.empty?
  n = s.to_i
  r = +""
  VALS.each do |v, sym|
    while n >= v
      r << sym
      n -= v
    end
  end
  out << r
end
print out.map { |x| x + "\n" }.join
