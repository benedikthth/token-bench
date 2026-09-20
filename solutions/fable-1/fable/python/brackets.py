import sys

PAIRS = {')': '(', ']': '[', '}': '{'}
OPENERS = set(PAIRS.values())


def balanced(line):
    stack = []
    for ch in line:
        if ch in OPENERS:
            stack.append(ch)
        elif ch in PAIRS:
            if not stack or stack.pop() != PAIRS[ch]:
                return False
        else:
            return False
    return not stack


def main():
    data = sys.stdin.read()
    lines = data.split('\n')
    if lines and lines[-1] == '':
        lines.pop()
    out = []
    for line in lines:
        out.append('yes' if balanced(line.rstrip('\r')) else 'no')
    sys.stdout.write('\n'.join(out) + ('\n' if out else ''))


if __name__ == '__main__':
    main()
