L:0:"/dev/stdin"
txt:(" ")/L
i:`i$txt
up:(i>64)&(i<91)
isl:up|(i>96)&(i<123)
lo:i+32*up
code2:(isl*lo)+(~isl)*32
s2:`c$code2
ws0:(" ")\s2
ws:ws0@&0<#'ws0
g:=ws
uw:!g
cnt:#'.g
idx1:<uw
c1:cnt@idx1
idx2:<(-1*c1)
ord:idx1@idx2
fw:uw@ord
fc:cnt@ord
`0:{x,(" "),$y}'[fw;fc]
