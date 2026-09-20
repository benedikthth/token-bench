lines: 1:0
text: ({x, " ", y}/) lines
text: {x|32}' text
words: text cut " "
freq: #' group words
distinct_words: asc distinct words
idx: iasc (neg freq[distinct_words], distinct_words)
sorted: distinct_words[idx]
-1 @' sorted ,' " " ,' string freq[sorted]
