words = STDIN.readlines.map(&:chomp)

# Group words by their sorted letters (anagram signature)
# Then sort words within each group, and sort groups by first word
words.group_by { |word| word.chars.sort.join }
     .values
     .map { |group| group.sort }
     .sort_by { |group| group.first }
     .each { |group| puts group.join(' ') }
