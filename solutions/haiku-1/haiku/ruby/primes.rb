n = gets.to_i

if n < 2
  puts ""
else
  # Sieve of Eratosthenes
  is_prime = Array.new(n + 1, true)
  is_prime[0] = is_prime[1] = false

  (2..Math.sqrt(n).to_i).each do |i|
    if is_prime[i]
      (i * i..n).step(i).each do |j|
        is_prime[j] = false
      end
    end
  end

  primes = (2..n).select { |i| is_prime[i] }
  puts primes.join(" ")
end
