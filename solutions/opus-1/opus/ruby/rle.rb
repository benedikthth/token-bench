s = ($stdin.gets || "").strip
out = s.chars.chunk_while { |a, b| a == b }.map { |r| "#{r[0]}#{r.size}" }.join
puts out
