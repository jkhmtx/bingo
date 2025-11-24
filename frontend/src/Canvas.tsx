import { createBingoCellsMatrix } from "./createBingoCellsMatrix";
import { INITIAL_W_PX, INITIAL_H_PX } from "./constant";
import type { Box } from "./useViewStateReducer";
import { useDrawOffscreenCanvas2dCallback } from "./useDrawOffscreenCanvas2dCallback";
import { useEffect, useMemo, type RefObject } from "react";

const STATIC_BINGO_CELLS_MATRIX = createBingoCellsMatrix();

type OnMouseEvent = (e: { clientX: number; clientY: number }) => void;

type CanvasProps = {
  boxes: Box[];
  image: HTMLImageElement;
  offscreenCanvas: OffscreenCanvas | undefined;
  onMouseDown: OnMouseEvent;
  onMouseMove: OnMouseEvent;
  onMouseUp: OnMouseEvent;
  ref: RefObject<HTMLCanvasElement | null>;
};

export function Canvas({
  boxes,
  image,
  offscreenCanvas,
  onMouseDown,
  onMouseMove,
  onMouseUp,
  ref,
}: CanvasProps) {
  const cards = useMemo(
    () => boxes.map((box) => ({ ...box, cells: STATIC_BINGO_CELLS_MATRIX })),
    [boxes],
  );

  const drawOffscreenCanvas = useDrawOffscreenCanvas2dCallback({
    canvas: offscreenCanvas,
    image,
  });

  useEffect(() => {
    const ctx = drawOffscreenCanvas(cards);

    const visibleCtx = ref.current?.getContext("2d");
    if (!ctx || !visibleCtx) {
      return;
    }

    for (const card of cards) {
      const w = card.scale * INITIAL_W_PX;
      const h = card.scale * INITIAL_H_PX;

      ctx.fillStyle = "yellow";
      ctx.beginPath();
      ctx.moveTo(card.x + w, card.y + h);
      ctx.lineTo(card.x + w * 0.8, card.y + h);
      ctx.lineTo(card.x + w, card.y + h * 0.8);
      ctx.fill();
    }

    visibleCtx.canvas.width = ctx.canvas.width;
    visibleCtx.canvas.height = ctx.canvas.height;

    visibleCtx.drawImage(ctx.canvas, 0, 0);
  }, [cards, drawOffscreenCanvas]);

  return (
    <div className="canvas__container">
      <canvas
        ref={ref}
        onMouseDown={onMouseDown}
        onTouchStart={(e) => {
          if (e.touches.length > 1) {
            return;
          }

          onMouseDown(e.touches.item(0));
        }}
        onMouseMove={onMouseMove}
        onTouchMove={(e) => {
          if (e.touches.length > 1) {
            return;
          }

          onMouseMove(e.touches.item(0));
        }}
        onMouseUp={onMouseUp}
        onTouchEnd={(e) => onMouseUp(e.touches.item(0))}
      ></canvas>
    </div>
  );
}
