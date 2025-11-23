import "./App.css";
import { Buttons } from "./Buttons";
import { Canvas } from "./Canvas";
import { ImageUpload } from "./ImageUpload";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useViewStateReducer } from "./useViewStateReducer";
import type { Box } from "./ViewState";
import { useDrawBackgroundImageCallback } from "./useDrawBackgroundImageCallback";
import { useGettingImageMemo } from "./useGettingImageMemo";
import { useRedrawCallback } from "./useRedrawCallback";
import { canvasCtxOrNone } from "./canvasCtxOrNone";
import { drawBingoCard } from "./drawBingoCard";
import { createBingoCellsMatrix } from "./createBingoCellsMatrix";

const IDENT = {
  1: "single",
  2: "double",
  3: "triple",
  4: "quadruple",
};

function useDownloadFromOffscreenCanvasCallback({
  boxes,
  imageUri,
  quantity,
  view,
}: {
  boxes: Box[];
  imageUri: string | undefined;
  quantity: number;
  view: 1 | 2 | 3 | 4;
}) {
  const ref = useRef<HTMLCanvasElement>(null);

  const redraw = useRedrawCallback(ref);
  const renderImage = useDrawBackgroundImageCallback(
    ref,
    { gettingImage: useGettingImageMemo(imageUri) },
    [imageUri],
  );
  const ident = IDENT[view];

  // runs once
  useEffect(() => {
    ref.current = document.createElement("canvas");
  }, []);

  return useCallback(() => {
    const canvasCtx = canvasCtxOrNone(ref);

    if (!canvasCtx) {
      return;
    }

    const { canvas, ctx } = canvasCtx;

    for (let i = 0; i < quantity; i++) {
      redraw();
      renderImage();
      for (const box of boxes) {
        drawBingoCard(ctx, box, createBingoCellsMatrix());
      }

      const dataURL = canvas.toDataURL("image/png");

      // Create a link to download the image
      const link = document.createElement("a");
      link.href = dataURL;
      link.download = `bingo-${ident}-${i}.png`;

      // Programmatically click the link to trigger download
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  }, [boxes, ident, redraw, renderImage, quantity]);
}

function App() {
  const [imageUri, setImageUri] = useState<string>();
  const ref = useRef<HTMLCanvasElement>(null);

  const [state, dispatch] = useViewStateReducer(ref);
  const boxes = useMemo(
    () => state.visible.map((id) => state.boxes[id]),
    [state],
  );

  const [quantity, setQuantity] = useState(1);
  const downloadFromOffscreenCanvasCallback =
    useDownloadFromOffscreenCanvasCallback({
      boxes,
      quantity,
      imageUri,
      view: state.view,
    });

  return (
    <>
      <ImageUpload setImageUri={setImageUri} />
      {imageUri && (
        <div className="image-view">
          <Buttons
            onDownloadClick={downloadFromOffscreenCanvasCallback}
            onViewButtonClick={(view) => dispatch({ type: "set-view", view })}
            quantity={quantity}
            setQuantity={setQuantity}
          />
          <Canvas
            boxes={boxes}
            imageUri={imageUri}
            onMouseDown={(e) =>
              dispatch({ type: "mouse-down", x: e.clientX, y: e.clientY })
            }
            onMouseMove={(e) =>
              dispatch({ type: "mouse-move", x: e.clientX, y: e.clientY })
            }
            onMouseUp={(e) =>
              dispatch({ type: "mouse-up", x: e.clientX, y: e.clientY })
            }
            ref={ref}
          />
        </div>
      )}
    </>
  );
}

export default App;
