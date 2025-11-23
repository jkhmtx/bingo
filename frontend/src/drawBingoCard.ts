import { INITIAL_W_PX, INITIAL_H_PX } from "./constant";
import type { Box } from "./ViewState";

export function drawBingoCard(
  ctx: CanvasRenderingContext2D,
  box: Box,
  cells: string[][],
) {
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

  for (let i = 0; i < cells.length; i++) {
    for (let j = 0; j < cells[i].length; j++) {
      const cell = cells[i][j];
      const x = box.x + (w * i) / 5 + w / 10;
      const y = box.y + (h * j) / 6 + h / 12;

      ctx.fillText(cell, x, y, w / 5 - 4);
    }
  }
}
