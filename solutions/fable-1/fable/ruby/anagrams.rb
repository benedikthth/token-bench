words = $stdin.read.to_s.split("\n").map(&:strip).reject(&:empty?)
groups = words.group_by { |w| w.chars.sort.join }
groups.values.map(&:sort).sort_by(&:first).each { |g| puts g.join(" ") }
