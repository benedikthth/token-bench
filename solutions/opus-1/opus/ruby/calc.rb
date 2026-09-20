def tdiv(a, b)
  q = a.abs / b.abs
  (a < 0) ^ (b < 0) ? -q : q
end

def evaluate(tokens)
  pos = 0
  factor = nil
  term = nil
  expr = lambda do
    v = term.call
    while pos < tokens.size && (tokens[pos] == '+' || tokens[pos] == '-')
      op = tokens[pos]
      pos += 1
      r = term.call
      v = op == '+' ? v + r : v - r
    end
    v
  end
  term = lambda do
    v = factor.call
    while pos < tokens.size && (tokens[pos] == '*' || tokens[pos] == '/')
      op = tokens[pos]
      pos += 1
      r = factor.call
      v = op == '*' ? v * r : tdiv(v, r)
    end
    v
  end
  factor = lambda do
    t = tokens[pos]
    pos += 1
    if t == '('
      v = expr.call
      pos += 1
      v
    else
      t.to_i
    end
  end
  expr.call
end

out = []
STDIN.each_line do |line|
  tokens = line.scan(/\d+|[-+*\/()]/)
  next if tokens.empty?
  out << evaluate(tokens)
end
puts out
