import sys

def is_balanced(line):
    stack = []
    matching = {'(': ')', '[': ']', '{': '}'}

    for char in line:
        if char in matching:  # opening bracket
            stack.append(char)
        else:  # closing bracket
            if not stack or matching[stack[-1]] != char:
                return False
            stack.pop()

    return len(stack) == 0

for line in sys.stdin:
    line = line.rstrip('\n')
    if is_balanced(line):
        print("yes")
    else:
        print("no")
