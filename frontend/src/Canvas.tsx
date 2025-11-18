import { useDrawBackgroundImageCallback } from "./useDrawBackgroundImageCallback";
import { useDrawRectanglesCallback } from "./useDrawRectanglesCallback";
import { useEffect, useRef } from "react";
import { useGettingImageMemo } from "./useGettingImageMemo";
import { useRedrawCallback } from "./useRedrawCallback";
import { useViewStateReducer } from "./ViewState";

type CanvasProps = {
  imageUri: string;
};

export function Canvas({ imageUri }: CanvasProps) {
  const ref = useRef<HTMLCanvasElement>(null);

  const [state, dispatch] = useViewStateReducer(ref);

  const gettingImage = useGettingImageMemo(imageUri);

  const redraw = useRedrawCallback(ref);
  const renderImage = useDrawBackgroundImageCallback(ref, { gettingImage }, [
    imageUri,
  ]);
  const drawRectangles = useDrawRectanglesCallback(ref, { state }, [state]);

  useEffect(() => {
    (async () => {
      for (const cb of [redraw, renderImage, drawRectangles]) {
        await cb();
      }
    })();
  }, [redraw, renderImage, drawRectangles]);

  return (
    <>
      <button type="button" onClick={() => dispatch({ type: "toggle-view" })}>
        Switch View
      </button>
      <canvas
        className="canvas"
        ref={ref}
        onMouseDown={(e) =>
          dispatch({ type: "mouse-down", x: e.clientX, y: e.clientY })
        }
        onMouseMove={(e) =>
          dispatch({ type: "mouse-move", x: e.clientX, y: e.clientY })
        }
        onMouseUp={(e) =>
          dispatch({ type: "mouse-up", x: e.clientX, y: e.clientY })
        }
      ></canvas>
    </>
  );
}
