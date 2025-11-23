import { defineCanvasCallback } from "./defineCanvasCallback";
import { INITIAL_H_PX, INITIAL_W_PX } from "./constant";
import type { Box } from "./ViewState";
import { drawBingoCard } from "./drawBingoCard";
import { createBingoCellsMatrix } from "./createBingoCellsMatrix";

const STATIC_BINGO_CELLS_MATRIX = createBingoCellsMatrix();

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
  boxes: Box[];
}>(({ ctx }, { boxes }) => {
  for (const box of boxes) {
    drawBingoCard(ctx, box, STATIC_BINGO_CELLS_MATRIX);
    drawResizeHandle(ctx, box);
  }
}, "useDrawRectanglesCallback");
