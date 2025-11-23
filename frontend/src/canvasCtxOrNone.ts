import type { RefObject } from "react";

export function canvasCtxOrNone(ref: RefObject<HTMLCanvasElement | null>) {
  const canvas = ref.current;
  const ctx = canvas?.getContext("2d");

  if (!canvas || !ctx) {
    return;
  }

  return { canvas, ctx };
}
