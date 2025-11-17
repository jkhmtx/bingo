import { useEffect, useReducer, useRef } from "react";
import { useDrawBackgroundImageCallback } from "./useDrawBackgroundImageCallback";
import { useRedrawCallback } from "./useRedrawCallback";
import { useDrawRectanglesCallback } from "./useDrawRectanglesCallback";

type CanvasProps = {
  imageUri: string;
};

export type Box = {
  x: number;
  y: number;
  scale: number;
  color: "red" | "green";
};

type BoxState = [Box, Box];

export type ViewState =
  | {
      type: "single";
      boxes: BoxState;
    }
  | {
      type: "double";
      boxes: BoxState;
    };

type ViewAction = {
  type: "toggle-view";
};

const INITIAL_BOXES: BoxState = [
  {
    x: 100,
    y: 100,
    scale: 1,
    color: "red",
  },
  {
    x: 200,
    y: 100,
    scale: 1,
    color: "green",
  },
];

export function Canvas({ imageUri }: CanvasProps) {
  const ref = useRef<HTMLCanvasElement>(null);

  const [state, dispatch] = useReducer<ViewState, [ViewAction]>(
    (state, action) => {
      switch (action.type) {
        case "toggle-view": {
          const isSingle = state.type === "single";
          return { type: isSingle ? "double" : "single", boxes: state.boxes };
        }
        default: {
          throw new Error("Unhandled");
        }
      }
    },
    {
      type: "single",
      boxes: INITIAL_BOXES,
    },
  );

  const redraw = useRedrawCallback(ref);
  const renderImage = useDrawBackgroundImageCallback(ref, { imageUri }, [
    imageUri,
  ]);
  const drawRectangles = useDrawRectanglesCallback(ref, { state }, [state]);

  useEffect(() => {
    for (const cb of [redraw, renderImage, drawRectangles]) {
      cb();
    }
  }, [redraw, renderImage, drawRectangles]);

  return (
    <>
      <button type="button" onClick={() => dispatch({ type: "toggle-view" })}>
        Switch View
      </button>
      <canvas className="canvas" ref={ref}></canvas>
    </>
  );
}
