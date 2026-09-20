import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class Main {
    private String s;
    private int pos;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            if (line.trim().isEmpty()) {
                continue;
            }
            Main m = new Main();
            long result = m.eval(line);
            out.append(result).append('\n');
        }
        System.out.print(out);
    }

    private long eval(String line) {
        this.s = line;
        this.pos = 0;
        long result = parseExpr();
        return result;
    }

    private void skipSpaces() {
        while (pos < s.length() && s.charAt(pos) == ' ') {
            pos++;
        }
    }

    private char peek() {
        skipSpaces();
        if (pos < s.length()) {
            return s.charAt(pos);
        }
        return '\0';
    }

    // expr := term (('+' | '-') term)*
    private long parseExpr() {
        long value = parseTerm();
        while (true) {
            char c = peek();
            if (c == '+') {
                pos++;
                value += parseTerm();
            } else if (c == '-') {
                pos++;
                value -= parseTerm();
            } else {
                break;
            }
        }
        return value;
    }

    // term := factor (('*' | '/') factor)*
    private long parseTerm() {
        long value = parseFactor();
        while (true) {
            char c = peek();
            if (c == '*') {
                pos++;
                value *= parseFactor();
            } else if (c == '/') {
                pos++;
                long rhs = parseFactor();
                value = value / rhs;
            } else {
                break;
            }
        }
        return value;
    }

    // factor := number | '(' expr ')'
    private long parseFactor() {
        char c = peek();
        if (c == '(') {
            pos++;
            long value = parseExpr();
            skipSpaces();
            if (pos < s.length() && s.charAt(pos) == ')') {
                pos++;
            }
            return value;
        }
        return parseNumber();
    }

    private long parseNumber() {
        skipSpaces();
        int start = pos;
        while (pos < s.length() && Character.isDigit(s.charAt(pos))) {
            pos++;
        }
        return Long.parseLong(s.substring(start, pos));
    }
}
