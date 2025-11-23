import "./App.css";
import { Buttons } from "./Buttons";
import { Canvas } from "./Canvas";
import { createBingoCellsMatrix } from "./createBingoCellsMatrix";
import { ImageUpload } from "./ImageUpload";
import { useDrawOffscreenCanvas2dCallback } from "./useDrawOffscreenCanvas2dCallback";
import { useImageMemo } from "./UseImageMemoProps";
import { useMemo, useRef, useState } from "react";
import { useOffscreenCanvasMemo } from "./useOffscreenCanvasMemo";
import { useViewStateReducer } from "./useViewStateReducer";

const IDENT = {
  1: "single",
  2: "double",
  3: "triple",
  4: "quadruple",
};

function App() {
  const [imageUri, setImageUri] = useState<string>();
  const ref = useRef<HTMLCanvasElement>(null);

  const [state, dispatch] = useViewStateReducer(ref);
  const boxes = useMemo(
    () => state.visible.map((id) => state.boxes[id]),
    [state],
  );

  const image = useImageMemo({ imageUri });

  const presentationalOffscreenCanvas = useOffscreenCanvasMemo({ image });
  const downloadableOffscreenCanvas = useOffscreenCanvasMemo({ image });

  const drawDownloadableCanvas = useDrawOffscreenCanvas2dCallback({
    canvas: downloadableOffscreenCanvas,
    image,
  });

  const [quantity, setQuantity] = useState(1);

  return (
    <>
      <ImageUpload setImageUri={setImageUri} />
      {image && (
        <div className="image-view">
          <Buttons
            onDownloadClick={async () => {
              const ident = IDENT[state.view];

              for (let i = 0; i < quantity; i++) {
                const ctx = drawDownloadableCanvas(
                  boxes.map((box) => ({
                    ...box,
                    cells: createBingoCellsMatrix(),
                  })),
                );

                if (!ctx) {
                  throw new Error("this should never happen");
                }

                const blob = await ctx.canvas.convertToBlob();
                const dataURL = URL.createObjectURL(blob);

                // Create a link to download the image
                const link = document.createElement("a");
                link.href = dataURL;
                link.download = `bingo-${ident}-${i}.png`;

                // Programmatically click the link to trigger download
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
              }
            }}
            onViewButtonClick={(view) => dispatch({ type: "set-view", view })}
            quantity={quantity}
            setQuantity={setQuantity}
          />
          <Canvas
            boxes={boxes}
            image={image}
            offscreenCanvas={presentationalOffscreenCanvas}
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
