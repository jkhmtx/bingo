import { type RefObject, type DependencyList, useCallback } from "react";
import { canvasOrNone } from "./canvasOrNone";

export function defineCanvasCallback<TProps = undefined, T = void>(
  cb: (
    {
      canvas,
      ctx,
    }: { canvas: HTMLCanvasElement; ctx: CanvasRenderingContext2D },
    props: TProps,
  ) => T,
  debugId: string,
): TProps extends undefined
  ? (
      ref: RefObject<HTMLCanvasElement | null>,
      props?: undefined,
      deps?: undefined,
    ) => () => Promise<T>
  : (
      ref: RefObject<HTMLCanvasElement | null>,
      props: TProps,
      deps: DependencyList,
    ) => () => Promise<T>;
export function defineCanvasCallback(
  cb: (
    {
      canvas,
      ctx,
    }: { canvas: HTMLCanvasElement; ctx: CanvasRenderingContext2D },
    props: unknown,
  ) => unknown,
  debugId: string,
): (
  ref: RefObject<HTMLCanvasElement | null>,
  props?: unknown,
  deps?: DependencyList,
) => () => Promise<unknown> {
  return (ref, props, deps) => {
    return useCallback(() => {
      return new Promise<unknown>((resolve) => {
        console.time(debugId);
        const canvas = canvasOrNone(ref);

        if (!canvas) {
          return;
        }

        const res = cb(canvas, props);
        console.timeEnd(debugId);

        resolve(res);
      });
    }, deps ?? []);
  };
}
