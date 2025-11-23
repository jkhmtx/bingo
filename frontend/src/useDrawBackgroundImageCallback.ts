import { defineCanvasCallback } from "./defineCanvasCallback";

export type UseRenderImageEffectProps = {
  gettingImage: Promise<HTMLImageElement | undefined>;
};

export const useDrawBackgroundImageCallback =
  defineCanvasCallback<UseRenderImageEffectProps>(
    async ({ canvas, ctx }, { gettingImage }) => {
      const image = await gettingImage;

      if (!image) {
        return;
      }

      canvas.width = image.width;
      canvas.height = image.height;

      ctx.drawImage(image, 0, 0);
    },
    "useDrawBackgroundImageCallback",
  );
