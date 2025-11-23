import { useEffect, useMemo, useRef } from "react";

type UseOffscreenCanvasMemoProps = {
  image: HTMLImageElement | undefined;
};

export function useOffscreenCanvasMemo({ image }: UseOffscreenCanvasMemoProps) {
  const offscreenCanvasRef = useRef<OffscreenCanvas>(null);

  // Only runs on first render
  useEffect(() => {
    offscreenCanvasRef.current = new OffscreenCanvas(0, 0);
  }, []);

  return useMemo(() => {
    const canvas = offscreenCanvasRef.current;
    if (!canvas || !image) {
      return;
    }

    canvas.width = image.width;
    canvas.height = image.height;

    return canvas;
  }, [image]);
}
