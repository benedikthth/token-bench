import java.io.*;
import java.math.BigInteger;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            out.append(eval(line)).append('\n');
        }
        System.out.print(out);
    }

    static int prec(char op) {
        return (op == '+' || op == '-') ? 1 : (op == '*' || op == '/') ? 2 : 0;
    }

    static void apply(ArrayDeque<BigInteger> vals, ArrayDeque<Character> ops) {
        char op = ops.pop();
        BigInteger b = vals.pop(), a = vals.pop();
        switch (op) {
            case '+': vals.push(a.add(b)); break;
            case '-': vals.push(a.subtract(b)); break;
            case '*': vals.push(a.multiply(b)); break;
            default: vals.push(a.divide(b)); break;
        }
    }

    static BigInteger eval(String s) {
        ArrayDeque<BigInteger> vals = new ArrayDeque<>();
        ArrayDeque<Character> ops = new ArrayDeque<>();
        int n = s.length();
        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            if (Character.isWhitespace(c)) continue;
            if (Character.isDigit(c)) {
                int j = i;
                while (j < n && Character.isDigit(s.charAt(j))) j++;
                vals.push(new BigInteger(s.substring(i, j)));
                i = j - 1;
            } else if (c == '(') {
                ops.push(c);
            } else if (c == ')') {
                while (ops.peek() != '(') apply(vals, ops);
                ops.pop();
            } else {
                while (!ops.isEmpty() && prec(ops.peek()) >= prec(c)) apply(vals, ops);
                ops.push(c);
            }
        }
        while (!ops.isEmpty()) apply(vals, ops);
        return vals.pop();
    }
}
