while line = STDIN.gets
  line = line.chomp

  stack = []
  balanced = true

  # Map closing brackets to their opening counterparts
  matches = { ')' => '(', ']' => '[', '}' => '{' }

  line.each_char do |char|
    if '([{'.include?(char)
      # Push opening brackets onto stack
      stack.push(char)
    elsif matches.key?(char)
      # Check if closing bracket matches top of stack
      if stack.empty? || stack[-1] != matches[char]
        balanced = false
        break
      end
      stack.pop
    end
  end

  # Stack must be empty for balanced brackets
  balanced = false unless stack.empty?

  puts balanced ? 'yes' : 'no'
end
