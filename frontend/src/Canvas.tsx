import { useDrawBackgroundImageCallback } from "./useDrawBackgroundImageCallback";
import { useDrawRectanglesCallback } from "./useDrawRectanglesCallback";
import { useEffect, useLayoutEffect, useRef } from "react";
import { useGettingImageMemo } from "./useGettingImageMemo";
import { useRedrawCallback } from "./useRedrawCallback";
import { useViewStateReducer, type ViewState } from "./ViewState";

type CanvasProps = {
  imageUri: string;
};

function submit(state: ViewState) {
  const boxes = state.visible.map((id) => state.boxes[id]);

  console.log(JSON.stringify(boxes, null, 2));
}

export function Canvas({ imageUri }: CanvasProps) {
  const ref = useRef<HTMLCanvasElement>(null);

  const [state, dispatch] = useViewStateReducer(ref);

  const redraw = useRedrawCallback(ref);
  const renderImage = useDrawBackgroundImageCallback(
    ref,
    { gettingImage: useGettingImageMemo(imageUri) },
    [imageUri],
  );
  const drawRectangles = useDrawRectanglesCallback(ref, { state }, [state]);

  useEffect(() => {
    (async () => {
      for (const cb of [redraw, renderImage, drawRectangles]) {
        await cb();
      }
    })();
  }, [redraw, renderImage, drawRectangles]);

  return (
    <div className="canvas">
      <div className="button-bar">
        {([1, 2, 3, 4] as const).map((view) => (
          <button
            key={view}
            type="button"
            onClick={() => dispatch({ type: "set-view", view })}
          >
            {view}
          </button>
        ))}
        <button className="submit" type="button" onClick={() => submit(state)}>
          Download
        </button>
      </div>
      <div className="canvas__container">
        <canvas
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
      </div>
    </div>
  );
}
