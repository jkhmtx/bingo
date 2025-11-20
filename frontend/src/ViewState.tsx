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
        mode: "drag";
        id: BoxId;
        startingPosition: { x: number; y: number };
      }
    | {
        mode: "resize";
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

function isOutsideBoundingBox(
  x: number,
  y: number,
  box: { x: number; y: number; w: number; h: number },
) {
  return x < box.x || x > box.x + box.w || y < box.y || y > box.y + box.h;
}

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
            .map((box) => {
              const boxW = box.scale * INITIAL_W_PX;
              const boxH = box.scale * INITIAL_H_PX;

              const boxInfo = { x: box.x, y: box.y, w: boxW, h: boxH };

              if (isOutsideBoundingBox(mouseX, mouseY, boxInfo)) {
                return undefined;
              }

              return { ...box, ...boxInfo };
            })
            .filter(Boolean)
            .at(0);

          if (!box) {
            return state;
          }

          console.log(box.scale);

          const isOutsideResizeBoundingBox = isOutsideBoundingBox(
            mouseX,
            mouseY,
            {
              x: box.x + box.w * 0.8,
              y: box.y + box.h * 0.8,
              w: box.w * 0.2,
              h: box.h * 0.2,
            },
          );

          return {
            ...state,
            mode: isOutsideResizeBoundingBox ? "drag" : "resize",
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

          switch (state.mode) {
            case "resize": {
              const box = state.boxes[state.id];

              const { x, y } = action;

              const relativeMousePosition = getMouseRelativePosition(
                canvas,
                x,
                y,
              );

              // minimization function where we take the derivative of
              // the distance equation for two points, and set the derivative
              // equal to zero.

              // Solving for x:
              // x = (x0 + m * y0) / (1 + m * m)

              // This is not quite right - there's a weird jump when we start the mousemove
              // event...?
              const slope = INITIAL_H_PX / INITIAL_W_PX;

              const bottomRightCornerX =
                relativeMousePosition.x +
                (slope * relativeMousePosition.y) / (1 + slope * slope);

              const scale = (bottomRightCornerX - box.x) / INITIAL_W_PX;

              for (const anyBox of state.visible.map((id) => state.boxes[id])) {
                // Don't allow really small or negative scale
                anyBox.scale = Math.max(scale, 0.5);
              }

              return { ...state };
            }
            case "drag": {
              const box = state.boxes[state.id];

              const { x, y } = action;

              const relativeMousePosition = getMouseRelativePosition(
                canvas,
                x,
                y,
              );

              const w = box.scale * INITIAL_W_PX;
              const h = box.scale * INITIAL_H_PX;
              box.x = relativeMousePosition.x - w / 2;
              box.y = relativeMousePosition.y - h / 2;

              return { ...state };
            }
          }
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
