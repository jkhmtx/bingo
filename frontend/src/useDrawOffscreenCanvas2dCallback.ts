import { INITIAL_W_PX, INITIAL_H_PX } from "./constant";
import type { Box } from "./useViewStateReducer";
import { useCallback } from "react";

type BingoCard = Box & {
  cells: string[][];
};

type UseDrawOffscreenCanvas2dEffectProps = {
  canvas: OffscreenCanvas | undefined;
  image: HTMLImageElement | undefined;
};

export function useDrawOffscreenCanvas2dCallback({
  canvas,
  image,
}: UseDrawOffscreenCanvas2dEffectProps) {
  return useCallback(
    (cards: BingoCard[]) => {
      if (!image) {
        return;
      }

      const ctx = canvas?.getContext("2d");

      if (!ctx) {
        throw new Error("Non-2d context already used!");
      }

      // Clear every frame
      ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);

      ctx.drawImage(image, 0, 0);

      let i = 0;
      for (const card of cards) {
        console.log({ card, i: i++ });
        const w = card.scale * INITIAL_W_PX;
        const h = card.scale * INITIAL_H_PX;

        ctx.fillStyle = "white";
        ctx.fillRect(card.x, card.y, w, h);

        ctx.strokeStyle = "grey";

        // Horizontal lines
        for (let i = 1; i < 6; i++) {
          const y = card.y + (h * i) / 6;
          ctx.moveTo(card.x, y);
          ctx.lineTo(card.x + w, y);
          ctx.stroke();
        }

        // Vertical lines
        for (let i = 1; i < 5; i++) {
          const x = card.x + (w * i) / 5;
          ctx.moveTo(x, card.y + h / 6);
          ctx.lineTo(x, card.y + h);
          ctx.stroke();
        }

        ctx.fillStyle = "black";
        ctx.font = `${w / 8}px Arial`;
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";

        for (let i = 0; i < card.cells.length; i++) {
          for (let j = 0; j < card.cells[i].length; j++) {
            const cell = card.cells[i][j];
            const x = card.x + (w * i) / 5 + w / 10;
            const y = card.y + (h * j) / 6 + h / 12;

            ctx.fillText(cell, x, y, w / 5 - 4);
          }
        }
      }
      return ctx;
    },
    [image, canvas],
  );
}
