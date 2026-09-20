#!/usr/bin/env ruby

class Calculator
  def initialize(expr)
    @tokens = tokenize(expr)
    @index = 0
  end

  def tokenize(expr)
    tokens = []
    i = 0
    while i < expr.length
      if expr[i] =~ /\s/
        # Skip whitespace
        i += 1
      elsif expr[i] =~ /\d/
        # Parse number
        num = ""
        while i < expr.length && expr[i] =~ /\d/
          num += expr[i]
          i += 1
        end
        tokens << [:NUMBER, num.to_i]
      elsif expr[i] == '+'
        tokens << [:PLUS, '+']
        i += 1
      elsif expr[i] == '-'
        tokens << [:MINUS, '-']
        i += 1
      elsif expr[i] == '*'
        tokens << [:MULT, '*']
        i += 1
      elsif expr[i] == '/'
        tokens << [:DIV, '/']
        i += 1
      elsif expr[i] == '('
        tokens << [:LPAREN, '(']
        i += 1
      elsif expr[i] == ')'
        tokens << [:RPAREN, ')']
        i += 1
      else
        i += 1
      end
    end
    tokens
  end

  def parse
    expr
  end

  private

  def expr
    left = term
    while @index < @tokens.length && (@tokens[@index][0] == :PLUS || @tokens[@index][0] == :MINUS)
      op = @tokens[@index][0]
      @index += 1
      right = term
      if op == :PLUS
        left = left + right
      else
        left = left - right
      end
    end
    left
  end

  def term
    left = factor
    while @index < @tokens.length && (@tokens[@index][0] == :MULT || @tokens[@index][0] == :DIV)
      op = @tokens[@index][0]
      @index += 1
      right = factor
      if op == :MULT
        left = left * right
      else
        # Integer division truncating toward zero
        left = (left.to_f / right).truncate
      end
    end
    left
  end

  def factor
    if @index >= @tokens.length
      raise "Unexpected end of expression"
    end

    if @tokens[@index][0] == :NUMBER
      result = @tokens[@index][1]
      @index += 1
      result
    elsif @tokens[@index][0] == :LPAREN
      @index += 1  # consume '('
      result = expr
      @index += 1  # consume ')'
      result
    else
      raise "Unexpected token: #{@tokens[@index]}"
    end
  end
end

while line = STDIN.gets
  line.chomp!
  next if line.empty?
  calculator = Calculator.new(line)
  puts calculator.parse
end
