key: {x[iasc x]}

/ Store all lines as we read them
alllines:: `s$()

/ Collect all lines
{alllines:: alllines, enlist x} each 0:

/ Group and sort
keys: key each alllines
groups: {alllines[where keys=x]} each ?keys
sorted_groups: {x[iasc x]} each groups
first: {x[0]} each sorted_groups
result: sorted_groups[iasc first]
{-1 " " sv x} each result
