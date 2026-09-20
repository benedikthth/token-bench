import sys

PAIRS = {')': '(', ']': '[', '}': '{'}


def balanced(line):
    stack = []
    for ch in line:
        if ch in '([{':
            stack.append(ch)
        elif ch in PAIRS:
            if not stack or stack.pop() != PAIRS[ch]:
                return False
    return not stack


def main():
    data = sys.stdin.read()
    out = []
    for line in data.split('\n') if data else []:
        out.append(line.strip())
    if data.endswith('\n'):
        out.pop()
    sys.stdout.write(''.join(('yes' if balanced(l) else 'no') + '\n' for l in out))


main()
