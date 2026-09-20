n = gets.to_i

if n < 2
  puts ""
else
  sieve = Array.new(n + 1, true)
  sieve[0] = false
  sieve[1] = false

  (2..Math.sqrt(n).to_i).each do |i|
    next unless sieve[i]
    (i * i).step(n, i) { |j| sieve[j] = false }
  end

  primes = (2..n).select { |i| sieve[i] }
  puts primes.join(" ")
end
