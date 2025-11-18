import { useEffect, useReducer, useRef } from "react";
import { useDrawBackgroundImageCallback } from "./useDrawBackgroundImageCallback";
import { useRedrawCallback } from "./useRedrawCallback";
import { useDrawRectanglesCallback } from "./useDrawRectanglesCallback";
import { useGettingImageMemo } from "./useGettingImageMemo";

type CanvasProps = {
  imageUri: string;
};

export type Box = {
  x: number;
  y: number;
  scale: number;
  color: "red" | "green" | "blue";
};

type BoxState = [Box, Box];

type ViewData = {
  single: [Box];
  double: BoxState;
};

export type ViewState = {
  type: "single" | "double";
} & ViewData;

type ViewAction = {
  type: "toggle-view";
};

const INITIAL_BOXES: ViewData = {
  single: [
    {
      x: 100,
      y: 100,
      scale: 1,
      color: "blue",
    },
  ],
  double: [
    {
      x: 200,
      y: 100,
      scale: 1,
      color: "green",
    },
    {
      x: 500,
      y: 100,
      scale: 1,
      color: "red",
    },
  ],
};

export function Canvas({ imageUri }: CanvasProps) {
  const ref = useRef<HTMLCanvasElement>(null);

  const [state, dispatch] = useReducer<ViewState, [ViewAction]>(
    (state, action) => {
      switch (action.type) {
        case "toggle-view": {
          const isSingle = state.type === "single";
          return { ...state, type: isSingle ? "double" : "single" };
        }
        default: {
          throw new Error("Unhandled");
        }
      }
    },
    {
      type: "single",
      ...INITIAL_BOXES,
    },
  );

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
      <canvas className="canvas" ref={ref}></canvas>
    </>
  );
}
