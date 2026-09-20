#!/usr/bin/env bqn

# Read all lines from stdin
lines ← •FLines "/dev/stdin"

# Parse integers from space-separated string
ParseInts ← {•ParseInt¨ •Split 𝕩 (@' ')}

# Get N, M, s, t
nm ← ParseInts lines.0
N ← nm.0
M ← nm.1
st ← ParseInts lines.(1+M)
s ← st.0
t ← st.1

# If s = t, answer is 0
(s = t) ⊢ (
  •Out "0"
) ⊣ (
  # Build edge list
  edges ← (↕M) ⊸ {ParseInts lines.(1+𝕩)}

  # Use Bellman-Ford style algorithm: relax edges N-1 times
  INF ← 2000000000
  dist ← {INF}¨ ↕N
  dist @⊸ s ⊢ 0

  # Relax edges N-1 times
  {
    {
      edge ← edges.𝕩
      u ← edge.0
      v ← edge.1
      w ← edge.2
      new_dist ← (dist.u) + w
      (new_dist < dist.v) ⊢ (dist @⊸ v ⊢ new_dist) ⊣ ⟨⟩
    }¨ ↕M
  }¨ ↕(N-1)

  # Output result
  (dist.t = INF) ⊢ •Out "¯1" ⊣ •Out •Fmt ⌊(dist.t)
)
