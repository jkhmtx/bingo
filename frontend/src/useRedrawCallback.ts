import { defineCanvasCallback } from "./defineCanvasCallback";

export const useRedrawCallback = defineCanvasCallback(({ canvas, ctx }) => {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
}, "useRedrawCallback");
