alllines:: ()
{alllines:: alllines, enlist x} each 0:
rc: `i$ " " vs alllines[0]
R: rc[0]
C: rc[1]
matrix: {`i$ " " vs x} each alllines[1:1+R]
result: +matrix
{-1 " " sv string x} each result
