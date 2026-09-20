const readline = require('readline');

class Parser {
  constructor(input) {
    this.input = input.trim();
    this.pos = 0;
  }

  skipWhitespace() {
    while (this.pos < this.input.length && this.input[this.pos] === ' ') {
      this.pos++;
    }
  }

  peek() {
    this.skipWhitespace();
    if (this.pos < this.input.length) {
      return this.input[this.pos];
    }
    return null;
  }

  parseNumber() {
    this.skipWhitespace();
    let num = 0;
    while (this.pos < this.input.length && /\d/.test(this.input[this.pos])) {
      num = num * 10 + parseInt(this.input[this.pos], 10);
      this.pos++;
    }
    return num;
  }

  parsePrimary() {
    this.skipWhitespace();
    if (this.peek() === '(') {
      this.pos++; // consume '('
      const result = this.parseExpression();
      this.skipWhitespace();
      this.pos++; // consume ')'
      return result;
    }
    return this.parseNumber();
  }

  parseMultDiv() {
    let result = this.parsePrimary();
    while (true) {
      const op = this.peek();
      if (op === '*' || op === '/') {
        this.pos++; // consume operator
        const right = this.parsePrimary();
        if (op === '*') {
          result = result * right;
        } else {
          // Integer division truncating toward zero
          result = Math.trunc(result / right);
        }
      } else {
        break;
      }
    }
    return result;
  }

  parseAddSub() {
    let result = this.parseMultDiv();
    while (true) {
      const op = this.peek();
      if (op === '+' || op === '-') {
        this.pos++; // consume operator
        const right = this.parseMultDiv();
        if (op === '+') {
          result = result + right;
        } else {
          result = result - right;
        }
      } else {
        break;
      }
    }
    return result;
  }

  parseExpression() {
    return this.parseAddSub();
  }

  parse() {
    return this.parseExpression();
  }
}

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', (line) => {
  if (line.trim()) {
    const parser = new Parser(line);
    const result = parser.parse();
    console.log(result);
  }
});
