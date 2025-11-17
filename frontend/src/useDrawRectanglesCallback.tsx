import type { Box, ViewState } from "./Canvas";
import { defineCanvasCallback } from "./defineCanvasCallback";

function drawBox(ctx: CanvasRenderingContext2D, box: Box) {
  console.log(box);
}

export const useDrawRectanglesCallback = defineCanvasCallback<{
  state: ViewState;
}>(({ ctx }, { state }) => {
  const boxes = state.type === "single" ? state.boxes.slice(0, 1) : state.boxes;

  for (const box of boxes) {
    drawBox(ctx, box);
  }
});
