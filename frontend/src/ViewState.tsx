import { useReducer, type RefObject } from "react";
import { canvasOrNone } from "./canvasOrNone";
import { INITIAL_W_PX, INITIAL_H_PX } from "./constant";

type BoxId = "red" | "green" | "blue";

export type Box = {
  x: number;
  y: number;
  scale: number;
  color: BoxId;
};
type BoxState = [Box, Box];
type ViewData = {
  single: [Box];
  double: BoxState;
};

export type ViewState = {
  type: "single" | "double";
  mouseMode: "none" | "drag";
} & ViewData;

type ViewAction =
  | {
      type: "toggle-view";
    }
  | {
      type: "mouse-down" | "mouse-move" | "mouse-up";
      x: number;
      y: number;
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

export function useViewStateReducer(ref: RefObject<HTMLCanvasElement | null>) {
  return useReducer<ViewState, [ViewAction]>(
    (state, action) => {
      switch (action.type) {
        case "toggle-view": {
          const isSingle = state.type === "single";
          return { ...state, type: isSingle ? "double" : "single" };
        }
        case "mouse-down": {
          const box = getBoxUnderMousedown(
            ref,
            state.type === "single" ? state.single : state.double,
            action.x,
            action.y,
          );

          if (!box) {
            return state;
          }

          return state;
        }
        case "mouse-move": {
          const canvas = canvasOrNone(ref)?.canvas;

          if (!canvas) {
            return state;
          }

          return state;
        }
        case "mouse-up": {
          const canvas = canvasOrNone(ref)?.canvas;

          if (!canvas) {
            return state;
          }

          return state;
        }
        default: {
          throw new Error("Unhandled");
        }
      }
    },
    {
      type: "single",
      mouseMode: "none",
      ...INITIAL_BOXES,
    },
  );
}

function getBoxUnderMousedown(
  ref: RefObject<HTMLCanvasElement | null>,
  boxes: Box[],
  x: number,
  y: number,
) {
  const canvas = canvasOrNone(ref)?.canvas;

  if (!canvas) {
    return;
  }

  const canvasBoundingBox = canvas.getBoundingClientRect();
  const mouseX = x - canvasBoundingBox.left;
  const mouseY = y - canvasBoundingBox.top;

  return boxes.find((box) => {
    const boxW = box.scale * INITIAL_W_PX;
    const boxH = box.scale * INITIAL_H_PX;

    const outsideBoundingBox =
      mouseX < box.x ||
      mouseX > box.x + boxW ||
      mouseY < box.y ||
      mouseY > box.y + boxH;

    return !outsideBoundingBox;
  });
}
