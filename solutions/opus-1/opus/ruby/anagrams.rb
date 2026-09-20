words = STDIN.read.split
groups = words.group_by { |w| w.chars.sort.join }.values.map(&:sort)
groups.sort_by! { |g| g[0] }
out = groups.map { |g| g.join(" ") }.join("\n")
STDOUT.write(out.empty? ? "" : out + "\n")
