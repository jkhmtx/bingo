import { defineCanvasCallback } from "./defineCanvasCallback";

export type UseRenderImageEffectProps = {
  imageUri: string;
};

export const useDrawBackgroundImageCallback =
  defineCanvasCallback<UseRenderImageEffectProps>(
    ({ canvas, ctx }, { imageUri }) => {
      const image = new Image();

      image.src = imageUri;

      image.onload = () => {
        canvas.width = image.width;
        canvas.height = image.height;

        ctx.drawImage(image, 0, 0);
      };
    },
  );
