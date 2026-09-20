import sys


def main():
    data = sys.stdin.read()
    line = data.split("\n", 1)[0] if data else ""

    result = []
    i = 0
    n = len(line)
    while i < n:
        j = i
        while j < n and line[j] == line[i]:
            j += 1
        result.append(f"{line[i]}{j - i}")
        i = j

    print("".join(result))


if __name__ == "__main__":
    main()
