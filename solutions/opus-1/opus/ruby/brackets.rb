PAIRS = { ')' => '(', ']' => '[', '}' => '{' }.freeze

out = []
STDIN.each_line do |line|
  s = line.chomp
  stack = []
  ok = true
  s.each_char do |c|
    case c
    when '(', '[', '{'
      stack << c
    when ')', ']', '}'
      if stack.pop != PAIRS[c]
        ok = false
        break
      end
    end
  end
  out << (ok && stack.empty? ? 'yes' : 'no')
end
puts out unless out.empty?
