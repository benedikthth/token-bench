n = STDIN.read.to_i
if n < 2
  puts ""
else
  sieve = Array.new(n + 1, true)
  sieve[0] = sieve[1] = false
  i = 2
  while i * i <= n
    if sieve[i]
      j = i * i
      while j <= n
        sieve[j] = false
        j += i
      end
    end
    i += 1
  end
  primes = []
  (2..n).each { |k| primes << k if sieve[k] }
  puts primes.join(" ")
end
