import { defineCanvasCallback } from "./defineCanvasCallback";
import { INITIAL_H_PX, INITIAL_W_PX } from "./constant";
import type { Box, ViewState } from "./ViewState";

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
const MATRIX = [
  ["B", ...bingo()],
  ["I", ...bingo()],
  ["N", ...bingo("FREE")],
  ["G", ...bingo()],
  ["O", ...bingo()],
];

function drawBox(ctx: CanvasRenderingContext2D, box: Box) {
  const w = box.scale * INITIAL_W_PX;
  const h = box.scale * INITIAL_H_PX;

  ctx.fillStyle = "white";
  ctx.fillRect(box.x, box.y, w, h);

  ctx.strokeStyle = "grey";

  // Horizontal lines
  for (let i = 1; i < 6; i++) {
    const y = box.y + (h * i) / 6;
    ctx.moveTo(box.x, y);
    ctx.lineTo(box.x + w, y);
    ctx.stroke();
  }

  // Vertical lines
  for (let i = 1; i < 5; i++) {
    const x = box.x + (w * i) / 5;
    ctx.moveTo(x, box.y + h / 6);
    ctx.lineTo(x, box.y + h);
    ctx.stroke();
  }

  ctx.fillStyle = "black";
  ctx.font = `${w / 8}px Arial`;
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";

  for (let i = 0; i < MATRIX.length; i++) {
    for (let j = 0; j < MATRIX[i].length; j++) {
      const cell = MATRIX[i][j];
      const x = box.x + (w * i) / 5 + w / 10;
      const y = box.y + (h * j) / 6 + h / 12;

      ctx.fillText(cell, x, y, w / 5 - 4);
    }
  }
}

function drawResizeHandle(ctx: CanvasRenderingContext2D, box: Box) {
  const w = box.scale * INITIAL_W_PX;
  const h = box.scale * INITIAL_H_PX;

  ctx.fillStyle = "yellow";
  ctx.beginPath();
  ctx.moveTo(box.x + w, box.y + h);
  ctx.lineTo(box.x + w * 0.8, box.y + h);
  ctx.lineTo(box.x + w, box.y + h * 0.8);
  ctx.fill();
}

export const useDrawRectanglesCallback = defineCanvasCallback<{
  state: ViewState;
}>(({ ctx }, { state }) => {
  const boxes = state.visible.map((id) => state.boxes[id]);

  for (const box of boxes) {
    drawBox(ctx, box);
    drawResizeHandle(ctx, box);
  }
}, "useDrawRectanglesCallback");
