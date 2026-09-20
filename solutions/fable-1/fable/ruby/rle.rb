line = $stdin.gets
s = line.nil? ? "" : line.chomp.strip
out = s.scan(/((.)\2*)/).map { |run, ch| "#{ch}#{run.length}" }.join
puts out
