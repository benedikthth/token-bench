import java.util.Scanner;

public class Main {
    static class ExpressionEvaluator {
        private String expr;
        private int pos;

        public ExpressionEvaluator(String expr) {
            this.expr = expr;
            this.pos = 0;
        }

        public long evaluate() {
            return parseExpression();
        }

        private void skipWhitespace() {
            while (pos < expr.length() && Character.isWhitespace(expr.charAt(pos))) {
                pos++;
            }
        }

        private long parseExpression() {
            long result = parseTerm();

            while (true) {
                skipWhitespace();
                if (pos >= expr.length()) break;

                char op = expr.charAt(pos);
                if (op != '+' && op != '-') break;

                pos++;
                long right = parseTerm();
                if (op == '+') {
                    result += right;
                } else {
                    result -= right;
                }
            }

            return result;
        }

        private long parseTerm() {
            long result = parseFactor();

            while (true) {
                skipWhitespace();
                if (pos >= expr.length()) break;

                char op = expr.charAt(pos);
                if (op != '*' && op != '/') break;

                pos++;
                long right = parseFactor();
                if (op == '*') {
                    result *= right;
                } else {
                    result /= right;
                }
            }

            return result;
        }

        private long parseFactor() {
            skipWhitespace();

            if (pos < expr.length() && expr.charAt(pos) == '(') {
                pos++; // skip '('
                long result = parseExpression();
                skipWhitespace();
                pos++; // skip ')'
                return result;
            }

            // Parse number
            long num = 0;
            while (pos < expr.length() && Character.isDigit(expr.charAt(pos))) {
                num = num * 10 + (expr.charAt(pos) - '0');
                pos++;
            }
            return num;
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            if (line.trim().isEmpty()) continue;
            ExpressionEvaluator evaluator = new ExpressionEvaluator(line);
            long result = evaluator.evaluate();
            System.out.println(result);
        }
    }
}
