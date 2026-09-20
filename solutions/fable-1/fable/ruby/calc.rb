class Parser
  def initialize(str)
    @tokens = str.scan(/\d+|[-+*\/()]/)
    @pos = 0
  end

  def parse
    v = expr
    v
  end

  private

  def peek
    @tokens[@pos]
  end

  def advance
    t = @tokens[@pos]
    @pos += 1
    t
  end

  def expr
    v = term
    while peek == '+' || peek == '-'
      op = advance
      r = term
      v = op == '+' ? v + r : v - r
    end
    v
  end

  def term
    v = factor
    while peek == '*' || peek == '/'
      op = advance
      r = factor
      if op == '*'
        v *= r
      else
        # truncate toward zero
        q = v.abs / r.abs
        v = (v < 0) ^ (r < 0) ? -q : q
      end
    end
    v
  end

  def factor
    t = advance
    if t == '('
      v = expr
      advance # ')'
      v
    else
      t.to_i
    end
  end
end

out = []
$stdin.each_line do |line|
  s = line.strip
  next if s.empty?
  out << Parser.new(s).parse
end
puts out.join("\n") unless out.empty?
