import { defineCanvasCallback } from "./defineCanvasCallback";
import { INITIAL_H_PX, INITIAL_W_PX } from "./constant";
import type { Box, ViewState } from "./ViewState";

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
