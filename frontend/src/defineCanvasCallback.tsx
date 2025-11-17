import { type RefObject, type DependencyList, useCallback } from "react";

export function defineCanvasCallback<TProps = undefined>(
  cb: (
    {
      canvas,
      ctx,
    }: { canvas: HTMLCanvasElement; ctx: CanvasRenderingContext2D },
    props: TProps,
  ) => void,
): TProps extends undefined
  ? (
      ref: RefObject<HTMLCanvasElement | null>,
      props?: undefined,
      deps?: undefined,
    ) => () => void
  : (
      ref: RefObject<HTMLCanvasElement | null>,
      props: TProps,
      deps: DependencyList,
    ) => () => void;
export function defineCanvasCallback(
  cb: (
    {
      canvas,
      ctx,
    }: { canvas: HTMLCanvasElement; ctx: CanvasRenderingContext2D },
    props: unknown,
  ) => () => void,
): (
  ref: RefObject<HTMLCanvasElement | null>,
  props?: unknown,
  deps?: DependencyList,
) => () => void {
  return (ref, props, deps) => {
    return useCallback(() => {
      const canvas = ref.current;
      const ctx = canvas?.getContext("2d");

      if (!canvas || !ctx) {
        return;
      }

      cb({ canvas, ctx }, props);
    }, deps ?? []);
  };
}
