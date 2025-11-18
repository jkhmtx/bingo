import { defineCanvasCallback } from "./defineCanvasCallback";

export type UseRenderImageEffectProps = {
  gettingImage: Promise<HTMLImageElement>;
};

export const useDrawBackgroundImageCallback =
  defineCanvasCallback<UseRenderImageEffectProps>(
    async ({ canvas, ctx }, { gettingImage }) => {
      const image = await gettingImage;
      canvas.width = image.width;
      canvas.height = image.height;

      ctx.drawImage(image, 0, 0);
    },
    "useDrawBackgroundImageCallback",
  );
