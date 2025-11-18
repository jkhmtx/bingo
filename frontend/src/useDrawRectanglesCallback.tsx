import type { Box, ViewState } from "./Canvas";
import { defineCanvasCallback } from "./defineCanvasCallback";

const INITIAL_W_PX = 227;
const INITIAL_H_PX = 262;

function drawBox(ctx: CanvasRenderingContext2D, box: Box) {
  const w = box.scale * INITIAL_W_PX;
  const h = box.scale * INITIAL_H_PX;

  ctx.fillStyle = box.color;
  ctx.fillRect(box.x, box.y, w, h);
}

export const useDrawRectanglesCallback = defineCanvasCallback<{
  state: ViewState;
}>(({ ctx }, { state }) => {
  const boxes = state.type === "single" ? state.single : state.double;

  for (const box of boxes) {
    drawBox(ctx, box);
  }
}, "useDrawRectanglesCallback");
