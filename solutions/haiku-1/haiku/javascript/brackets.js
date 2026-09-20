const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  terminal: false
});

const matches = {
  ')': '(',
  ']': '[',
  '}': '{'
};

const isOpenBracket = (char) => ['(', '[', '{'].includes(char);
const isCloseBracket = (char) => [')', ']', '}'].includes(char);

rl.on('line', (line) => {
  const stack = [];
  let isBalanced = true;

  for (const char of line) {
    if (isOpenBracket(char)) {
      stack.push(char);
    } else if (isCloseBracket(char)) {
      if (stack.length === 0 || stack[stack.length - 1] !== matches[char]) {
        isBalanced = false;
        break;
      }
      stack.pop();
    }
  }

  if (isBalanced && stack.length === 0) {
    console.log('yes');
  } else {
    console.log('no');
  }
});
