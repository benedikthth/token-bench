"use strict";
const input = require("fs").readFileSync(0, "utf8");
const counts = new Map();
const re = /[A-Za-z]+/g;
let m;
while ((m = re.exec(input)) !== null) {
  const w = m[0].toLowerCase();
  counts.set(w, (counts.get(w) || 0) + 1);
}
const entries = [...counts.entries()];
entries.sort((a, b) => (b[1] - a[1]) || (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
const out = entries.map(([w, c]) => `${w} ${c}`).join("\n");
process.stdout.write(out ? out + "\n" : "");
