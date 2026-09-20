pairs = { ')' => '(', ']' => '[', '}' => '{' }
opens = pairs.values

STDIN.each_line do |line|
  line = line.chomp
  stack = []
  balanced = true

  line.each_char do |ch|
    if opens.include?(ch)
      stack.push(ch)
    elsif pairs.key?(ch)
      if stack.pop != pairs[ch]
        balanced = false
        break
      end
    end
  end

  balanced = false unless stack.empty?
  puts(balanced ? 'yes' : 'no')
end
