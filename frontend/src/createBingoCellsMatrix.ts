function bingo(free?: "FREE") {
  const col = [];
  for (let i = 0; i < 5; i++) {
    if (free && i === 2) {
      col.push("FREE");
    } else {
      col.push(Math.random() > 0.5 ? "42" : "1");
    }
  }

  return col;
}
export function createBingoCellsMatrix() {
  return [
    ["B", ...bingo()],
    ["I", ...bingo()],
    ["N", ...bingo("FREE")],
    ["G", ...bingo()],
    ["O", ...bingo()],
  ];
}
