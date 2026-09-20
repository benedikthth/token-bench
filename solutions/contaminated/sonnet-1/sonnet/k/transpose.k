lines: 0:"/dev/stdin"
rc: . lines[0]
R: rc[0]
C: rc[1]
rows: {. x}' R#1_lines
cols: +rows
{`0:," "/$x}' cols;
