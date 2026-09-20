import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            if (line.endsWith("\r")) line = line.substring(0, line.length() - 1);
            out.append(balanced(line) ? "yes" : "no").append('\n');
        }
        System.out.print(out);
    }

    static boolean balanced(String s) {
        char[] stack = new char[s.length()];
        int top = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '(': case '[': case '{':
                    stack[top++] = c;
                    break;
                case ')':
                    if (top == 0 || stack[--top] != '(') return false;
                    break;
                case ']':
                    if (top == 0 || stack[--top] != '[') return false;
                    break;
                case '}':
                    if (top == 0 || stack[--top] != '{') return false;
                    break;
                default:
                    return false;
            }
        }
        return top == 0;
    }
}
