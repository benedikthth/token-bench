counts = Hash.new(0)
$stdin.binmode.read.scan(/[A-Za-z]+/) { |w| counts[w.downcase] += 1 }
out = counts.sort_by { |w, c| [-c, w] }.map { |w, c| "#{w} #{c}\n" }.join
$stdout.write(out)
