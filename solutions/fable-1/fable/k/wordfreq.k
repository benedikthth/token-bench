/ word frequency: maximal runs of ASCII letters, case-insensitive
/ read all of stdin (fd 0) until EOF, then lowercase
s:_{x,1:0}/""
/ letters -> keep, anything else -> space
m:(s>"`")&s<"{"
s:@[s;&~m;:;" "]
w:" "\s
w:w@&0<#'w
/ group and count
c:#'=w
k:!c
v:.c
/ sort by word ascending, then stable sort by count descending
i:<k
k:k@i
v:v@i
i:<-v
k:k@i
v:v@i
r:{x," ",$y}'[k;v]
$[#r;`0:r;]
