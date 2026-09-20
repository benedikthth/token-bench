counts = Hash.new(0)
$stdin.binmode
$stdin.read.to_s.scan(/[A-Za-z]+/n) { |w| counts[w.downcase] += 1 }
out = counts.sort_by { |w, c| [-c, w] }.map { |w, c| "#{w} #{c}" }
puts out unless out.empty?
