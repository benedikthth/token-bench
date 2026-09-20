def to_roman(n)
  # Mapping of values to Roman numerals in descending order
  # Includes subtractive forms: IV, IX, XL, XC, CD, CM
  values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
  numerals = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']

  result = ""

  values.each_with_index do |value, index|
    while n >= value
      result += numerals[index]
      n -= value
    end
  end

  result
end

# Read input and convert each number
while line = STDIN.gets
  n = line.strip.to_i
  puts to_roman(n)
end
