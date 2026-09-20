line = gets&.chomp || ""
result = line.chars.chunk { |c| c }.map { |char, group| "#{char}#{group.size}" }.join
puts result
