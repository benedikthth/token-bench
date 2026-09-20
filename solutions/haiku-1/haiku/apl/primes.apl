input ← ⎕NGET '/proc/self/fd/0' 1
N ← ⌊⊃⊃input

:If N < 2
    ⎕NPUT '/dev/stdout' (,⊂'') 1
:Else
    ⍝ Sieve of Eratosthenes
    ⍝ Create bit vector where index k represents number k-1
    ⍝ So: index 1=number 0, index 2=number 1, ..., index N+1=number N
    is_prime ← (N+1)⍴1
    is_prime[1] ← 0  ⍝ 0 is not prime
    is_prime[2] ← 0  ⍝ 1 is not prime

    i ← 2
    :While i*i ≤ N
        :If is_prime[i+1]  ⍝ Check if number i is prime (stored at index i+1)
            ⍝ Mark all multiples of i starting from i² as not prime
            j ← i*i
            :While j ≤ N
                is_prime[j+1] ← 0
                j ← j+i
            :EndWhile
        :End
        i ← i+1
    :EndWhile

    ⍝ Extract primes: convert indices to numbers
    primes ← (⍸is_prime) - 1

    ⍝ Format and output
    :If 0 = ≢primes
        ⎕NPUT '/dev/stdout' (,⊂'') 1
    :Else
        output ← 1 ↓ ∊ ' ' , ⍕¨ primes
        ⎕NPUT '/dev/stdout' (,⊂output) 1
    :EndIf
:EndIf
