line = gets
line = line ? line.chomp : ""

output = line.chars.chunk { |c| c }.map { |c, arr| "#{c}#{arr.length}" }.join
puts output
