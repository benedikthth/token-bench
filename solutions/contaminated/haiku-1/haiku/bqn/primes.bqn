N ← ⌊ •ParseFloat •GetLine ""

IsPrime ← {
  n ← 𝕩
  (n < 2) ? 0 ;
  (n = 2) ? 1 ;
  (0 = 2 | n) ? 0 ;
  {
    i ← 𝕩
    (i × i > n) ? 1 ;
    (0 = n | i) ? 0 ;
    𝕊 (i + 2)
  } 3
}

Primes ← (IsPrime¨ ↕(N+1)) / ↕(N+1)

Output ← {
  (0 < ≠Primes) ? •Out 1↓∾{" "∾𝕩}¨•Fmt¨Primes ; •Out ""
}

Output ""
