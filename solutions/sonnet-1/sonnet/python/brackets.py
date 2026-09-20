import sys

PAIRS = {')': '(', ']': '[', '}': '{'}
OPEN = set(PAIRS.values())


def is_balanced(line):
    stack = []
    for ch in line:
        if ch in OPEN:
            stack.append(ch)
        elif ch in PAIRS:
            if not stack or stack.pop() != PAIRS[ch]:
                return False
    return not stack


def main():
    lines = sys.stdin.read().split('\n')
    if lines and lines[-1] == '':
        lines.pop()
    out = []
    for line in lines:
        out.append('yes' if is_balanced(line) else 'no')
    sys.stdout.write('\n'.join(out) + ('\n' if out else ''))


if __name__ == '__main__':
    main()
