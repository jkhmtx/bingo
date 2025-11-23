import { useDrawBackgroundImageCallback } from "./useDrawBackgroundImageCallback";
import { useDrawResizableBoxesCallback } from "./useDrawResizableBoxesCallback";
import { useEffect, type RefObject } from "react";
import { useGettingImageMemo } from "./useGettingImageMemo";
import { useRedrawCallback } from "./useRedrawCallback";
import type { Box } from "./ViewState";

type OnMouseEvent = (e: { clientX: number; clientY: number }) => void;

type CanvasProps = {
  boxes: Box[];
  imageUri: string;
  onMouseDown: OnMouseEvent;
  onMouseMove: OnMouseEvent;
  onMouseUp: OnMouseEvent;
  ref: RefObject<HTMLCanvasElement | null>;
};

export function Canvas({
  boxes,
  imageUri,
  onMouseDown,
  onMouseMove,
  onMouseUp,
  ref,
}: CanvasProps) {
  const redraw = useRedrawCallback(ref);
  const renderImage = useDrawBackgroundImageCallback(
    ref,
    { gettingImage: useGettingImageMemo(imageUri) },
    [imageUri],
  );
  const drawResizableBoxes = useDrawResizableBoxesCallback(ref, { boxes }, [
    boxes,
  ]);

  useEffect(() => {
    (async () => {
      for (const cb of [redraw, renderImage, drawResizableBoxes]) {
        await cb();
      }
    })();
  }, [redraw, renderImage, drawResizableBoxes]);

  return (
    <div className="canvas__container">
      <canvas
        ref={ref}
        onMouseDown={onMouseDown}
        onMouseMove={onMouseMove}
        onMouseUp={onMouseUp}
      ></canvas>
    </div>
  );
}
