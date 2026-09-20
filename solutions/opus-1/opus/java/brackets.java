import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            char[] stack = new char[line.length()];
            int top = 0;
            boolean ok = true;
            for (int i = 0; i < line.length() && ok; i++) {
                char c = line.charAt(i);
                switch (c) {
                    case '(': stack[top++] = ')'; break;
                    case '[': stack[top++] = ']'; break;
                    case '{': stack[top++] = '}'; break;
                    case ')': case ']': case '}':
                        if (top == 0 || stack[--top] != c) ok = false;
                        break;
                    default: break;
                }
            }
            out.append(ok && top == 0 ? "yes" : "no").append('\n');
        }
        System.out.print(out);
    }
}
