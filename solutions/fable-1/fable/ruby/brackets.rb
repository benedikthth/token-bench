PAIRS = { ')' => '(', ']' => '[', '}' => '{' }.freeze
OPENERS = PAIRS.values.freeze

def balanced?(line)
  stack = []
  line.each_char do |c|
    if OPENERS.include?(c)
      stack.push(c)
    elsif PAIRS.key?(c)
      return false if stack.pop != PAIRS[c]
    else
      return false
    end
  end
  stack.empty?
end

out = []
$stdin.each_line do |raw|
  line = raw.chomp.delete("\r")
  out << (balanced?(line) ? 'yes' : 'no')
end
puts out.join("\n") unless out.empty?
