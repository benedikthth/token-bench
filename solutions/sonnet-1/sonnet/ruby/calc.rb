class Parser
  def initialize(str)
    @s = str
    @pos = 0
    @len = str.length
  end

  def parse
    result = parse_expr
    result
  end

  private

  def skip_spaces
    @pos += 1 while @pos < @len && @s[@pos] == ' '
  end

  def peek
    skip_spaces
    @pos < @len ? @s[@pos] : nil
  end

  def parse_expr
    value = parse_term
    loop do
      c = peek
      if c == '+'
        @pos += 1
        value += parse_term
      elsif c == '-'
        @pos += 1
        value -= parse_term
      else
        break
      end
    end
    value
  end

  def parse_term
    value = parse_factor
    loop do
      c = peek
      if c == '*'
        @pos += 1
        value *= parse_factor
      elsif c == '/'
        @pos += 1
        divisor = parse_factor
        value = value.abs.div(divisor.abs) * ((value < 0) == (divisor < 0) ? 1 : -1)
      else
        break
      end
    end
    value
  end

  def parse_factor
    c = peek
    if c == '('
      @pos += 1
      value = parse_expr
      skip_spaces
      @pos += 1 if peek == ')'
      value
    else
      parse_number
    end
  end

  def parse_number
    skip_spaces
    start = @pos
    @pos += 1 while @pos < @len && @s[@pos] =~ /[0-9]/
    @s[start...@pos].to_i
  end
end

STDIN.each_line do |line|
  line = line.chomp
  next if line.strip.empty?
  puts Parser.new(line).parse
end
