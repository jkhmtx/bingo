import { useMemo } from "react";

export function useGettingImageMemo(imageUri: string | undefined) {
  return useMemo(() => {
    return new Promise<HTMLImageElement>((resolve) => {
      if (!imageUri) {
        return;
      }

      const image = new Image();

      image.src = imageUri;

      image.onload = () => {
        resolve(image);
      };
    });
  }, [imageUri]);
}
