import sys

class Calculator:
    def __init__(self, expr):
        self.expr = expr.replace(" ", "")
        self.pos = 0

    def parse(self):
        return self.parse_expr()

    def parse_expr(self):
        """Parse addition and subtraction (lowest precedence)"""
        result = self.parse_term()
        while self.pos < len(self.expr) and self.expr[self.pos] in "+-":
            op = self.expr[self.pos]
            self.pos += 1
            right = self.parse_term()
            if op == "+":
                result = result + right
            else:
                result = result - right
        return result

    def parse_term(self):
        """Parse multiplication and division (higher precedence)"""
        result = self.parse_factor()
        while self.pos < len(self.expr) and self.expr[self.pos] in "*/":
            op = self.expr[self.pos]
            self.pos += 1
            right = self.parse_factor()
            if op == "*":
                result = result * right
            else:
                result = int(result / right)  # int() truncates toward zero
        return result

    def parse_factor(self):
        """Parse parentheses and numbers (highest precedence)"""
        if self.expr[self.pos] == "(":
            self.pos += 1
            result = self.parse_expr()
            self.pos += 1  # skip ")"
            return result
        else:
            return self.parse_number()

    def parse_number(self):
        """Parse a number"""
        start = self.pos
        while self.pos < len(self.expr) and self.expr[self.pos].isdigit():
            self.pos += 1
        return int(self.expr[start:self.pos])

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    calc = Calculator(line)
    print(calc.parse())
