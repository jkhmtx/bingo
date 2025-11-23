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
