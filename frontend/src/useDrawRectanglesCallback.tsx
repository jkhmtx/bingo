import { defineCanvasCallback } from "./defineCanvasCallback";
import { INITIAL_H_PX, INITIAL_W_PX } from "./constant";
import type { Box, ViewState } from "./ViewState";

function drawBox(ctx: CanvasRenderingContext2D, box: Box) {
  const w = box.scale * INITIAL_W_PX;
  const h = box.scale * INITIAL_H_PX;

  ctx.fillStyle = box.color;
  ctx.fillRect(box.x, box.y, w, h);
}

function drawOutline(ctx: CanvasRenderingContext2D, box: Box) {
  const w = box.scale * INITIAL_W_PX;
  const h = box.scale * INITIAL_H_PX;

  ctx.fillStyle = "white";
  ctx.fillRect(box.x, box.y, w, 2);
  ctx.fillRect(box.x, box.y, 2, h);
  ctx.fillRect(box.x + w, box.y, 2, h);
  ctx.fillRect(box.x, box.y + h, w, 2);
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
    drawOutline(ctx, box);
    drawResizeHandle(ctx, box);
  }
}, "useDrawRectanglesCallback");
