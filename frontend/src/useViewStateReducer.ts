import { INITIAL_W_PX, INITIAL_H_PX } from "./constant";
import { type RefObject, useReducer } from "react";

type BoxId = `${number}-${number}`;

export type Box = {
  x: number;
  y: number;
  scale: number;
};

export type ViewData = {
  view: 1 | 2 | 3 | 4;
  visible: BoxId[];
  1: BoxId[];
  2: BoxId[];
  3: BoxId[];
  4: BoxId[];
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

const INITIAL_BOXES: ViewData = {
  view: 1,
  visible: ["1-1"],
  1: ["1-1"],
  2: ["2-1", "2-2"],
  3: ["3-1", "3-2", "3-3"],
  4: ["4-1", "4-2", "4-3", "4-4"],
  boxes: {
    "1-1": {
      x: 100,
      y: 100,
      scale: 1,
    },
    "2-1": {
      x: 200,
      y: 100,
      scale: 1,
    },
    "2-2": {
      x: 500,
      y: 100,
      scale: 1,
    },
    "3-1": {
      x: 200,
      y: 100,
      scale: 1,
    },
    "3-2": {
      x: 500,
      y: 100,
      scale: 1,
    },
    "3-3": {
      x: 300,
      y: 300,
      scale: 1,
    },
    "4-1": {
      x: 200,
      y: 100,
      scale: 1,
    },
    "4-2": {
      x: 500,
      y: 100,
      scale: 1,
    },
    "4-3": {
      x: 300,
      y: 300,
      scale: 1,
    },
    "4-4": {
      x: 400,
      y: 400,
      scale: 1,
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

function getMouseRelativePosition(
  canvas: HTMLCanvasElement,
  x: number,
  y: number,
): { x: number; y: number } {
  const canvasBoundingBox = canvas.getBoundingClientRect();

  return { x: x - canvasBoundingBox.left, y: y - canvasBoundingBox.top };
}

type ViewAction =
  | {
      type: "set-view";
      view: 1 | 2 | 3 | 4;
    }
  | {
      type: "mouse-down" | "mouse-move" | "mouse-up";
      x: number;
      y: number;
    };

export function useViewStateReducer(ref: RefObject<HTMLCanvasElement | null>) {
  return useReducer<ViewState, [ViewAction]>(
    (state, action) => {
      switch (action.type) {
        case "set-view": {
          return { ...state, visible: state[action.view], view: action.view };
        }
        case "mouse-down": {
          const canvas = ref.current?.getContext("2d")?.canvas;

          if (!canvas) {
            return state;
          }

          const { x: mouseX, y: mouseY } = getMouseRelativePosition(
            canvas,
            action.x,
            action.y,
          );

          const box = state.visible
            .map((id) => [id, state.boxes[id]] as const)
            .map(([id, box]) => {
              const boxW = box.scale * INITIAL_W_PX;
              const boxH = box.scale * INITIAL_H_PX;

              const boxInfo = { id, x: box.x, y: box.y, w: boxW, h: boxH };

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
            id: box.id,
            startingPosition: { x: action.x, y: action.y },
          };
        }
        case "mouse-move": {
          if (state.mode === "none") {
            return state;
          }
          const canvas = ref.current?.getContext("2d")?.canvas;

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
            view: state.view,
            visible: state.visible,
            boxes: state.boxes,
            1: state[1],
            2: state[2],
            3: state[3],
            4: state[4],
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
