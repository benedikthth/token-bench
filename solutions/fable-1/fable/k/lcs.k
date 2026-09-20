/ Longest common subsequence length, row-wise DP with max-scan
l:0:"/dev/stdin"
l:l,(0|2-#l)#,""
l:{x^"\r"}'l
a:l[0];b:l[1]
r:{|\x|0,(-1_x)+y=b}/[(1+#b)#0;a]
`0:$*|r
