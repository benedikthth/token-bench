import java.io.*;
import java.math.BigInteger;

public class Main {
    private static String s;
    private static int pos;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            s = line;
            pos = 0;
            BigInteger v = parseExpr();
            out.append(v.toString()).append('\n');
        }
        System.out.print(out);
        System.out.flush();
    }

    private static void skipSpaces() {
        while (pos < s.length() && Character.isWhitespace(s.charAt(pos))) pos++;
    }

    private static BigInteger parseExpr() {
        BigInteger v = parseTerm();
        while (true) {
            skipSpaces();
            if (pos >= s.length()) break;
            char c = s.charAt(pos);
            if (c == '+') {
                pos++;
                v = v.add(parseTerm());
            } else if (c == '-') {
                pos++;
                v = v.subtract(parseTerm());
            } else {
                break;
            }
        }
        return v;
    }

    private static BigInteger parseTerm() {
        BigInteger v = parseFactor();
        while (true) {
            skipSpaces();
            if (pos >= s.length()) break;
            char c = s.charAt(pos);
            if (c == '*') {
                pos++;
                v = v.multiply(parseFactor());
            } else if (c == '/') {
                pos++;
                BigInteger d = parseFactor();
                v = v.divide(d); // BigInteger.divide truncates toward zero
            } else {
                break;
            }
        }
        return v;
    }

    private static BigInteger parseFactor() {
        skipSpaces();
        if (pos < s.length() && s.charAt(pos) == '(') {
            pos++;
            BigInteger v = parseExpr();
            skipSpaces();
            if (pos < s.length() && s.charAt(pos) == ')') pos++;
            return v;
        }
        int start = pos;
        while (pos < s.length() && Character.isDigit(s.charAt(pos))) pos++;
        if (start == pos) return BigInteger.ZERO;
        return new BigInteger(s.substring(start, pos));
    }
}
