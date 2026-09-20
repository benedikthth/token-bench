# Read two strings
s1 = gets.chomp
s2 = gets.chomp

m = s1.length
n = s2.length

# Create DP table
dp = Array.new(m + 1) { Array.new(n + 1, 0) }

# Fill the DP table
(1..m).each do |i|
  (1..n).each do |j|
    if s1[i - 1] == s2[j - 1]
      dp[i][j] = dp[i - 1][j - 1] + 1
    else
      dp[i][j] = [dp[i - 1][j], dp[i][j - 1]].max
    end
  end
end

# Output the result
puts dp[m][n]
