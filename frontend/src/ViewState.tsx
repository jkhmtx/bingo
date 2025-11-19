import { useReducer, type RefObject } from "react";
import { canvasOrNone } from "./canvasOrNone";
import { INITIAL_W_PX, INITIAL_H_PX } from "./constant";

type BoxColor = "red" | "green" | "blue";
type BoxId = BoxColor;

export type Box = {
  x: number;
  y: number;
  scale: number;
  color: BoxColor;
};
type ViewData = {
  visible: BoxId[];
  boxes: Record<BoxId, Box>;
};

export type ViewState = ViewData &
  (
    | {
        mode: `drag`;
        id: BoxId;
        startingPosition: { x: number; y: number };
      }
    | {
        mode: "none";
      }
  );

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
  visible: ["blue"],
  boxes: {
    blue: {
      x: 100,
      y: 100,
      scale: 1,
      color: "blue",
    },
    green: {
      x: 200,
      y: 100,
      scale: 1,
      color: "green",
    },
    red: {
      x: 500,
      y: 100,
      scale: 1,
      color: "red",
    },
  },
};

export function useViewStateReducer(ref: RefObject<HTMLCanvasElement | null>) {
  return useReducer<ViewState, [ViewAction]>(
    (state, action) => {
      console.log(action.type);
      switch (action.type) {
        case "toggle-view": {
          const visible: BoxId[] =
            state.visible.length === 1 ? ["red", "green"] : ["blue"];

          return { ...state, visible };
        }
        case "mouse-down": {
          const canvas = canvasOrNone(ref)?.canvas;

          if (!canvas) {
            return state;
          }

          const { x: mouseX, y: mouseY } = getMouseRelativePosition(
            canvas,
            action.x,
            action.y,
          );

          const box = state.visible
            .map((id) => state.boxes[id])
            .find((box) => {
              const boxW = box.scale * INITIAL_W_PX;
              const boxH = box.scale * INITIAL_H_PX;

              const outsideBoundingBox =
                mouseX < box.x ||
                mouseX > box.x + boxW ||
                mouseY < box.y ||
                mouseY > box.y + boxH;

              return !outsideBoundingBox;
            });

          if (!box) {
            return state;
          }

          return {
            ...state,
            mode: "drag",
            id: box.color,
            startingPosition: { x: action.x, y: action.y },
          };
        }
        case "mouse-move": {
          if (state.mode === "none") {
            return state;
          }
          const canvas = canvasOrNone(ref)?.canvas;

          if (!canvas) {
            return state;
          }

          const box = state.boxes[state.id];

          const { x, y } = action;

          const relativeMousePosition = getMouseRelativePosition(canvas, x, y);

          const w = box.scale * INITIAL_W_PX;
          const h = box.scale * INITIAL_H_PX;
          box.x = relativeMousePosition.x - w / 2;
          box.y = relativeMousePosition.y - h / 2;

          return { ...state };
        }
        case "mouse-up": {
          return {
            mode: "none",
            visible: state.visible,
            boxes: state.boxes,
          };
        }
        default: {
          throw new Error("Unhandled");
        }
      }
    },
    {
      mode: "none",
      ...INITIAL_BOXES,
    },
  );
}

function getMouseRelativePosition(
  canvas: HTMLCanvasElement,
  x: number,
  y: number,
): { x: number; y: number } {
  const canvasBoundingBox = canvas.getBoundingClientRect();
  return { x: x - canvasBoundingBox.left, y: y - canvasBoundingBox.top };
}
