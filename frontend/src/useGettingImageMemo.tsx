import { useMemo } from "react";

export function useGettingImageMemo(imageUri: string) {
  return useMemo(() => {
    return new Promise<HTMLImageElement>((resolve) => {
      const image = new Image();

      image.src = imageUri;

      image.onload = () => {
        resolve(image);
      };
    });
  }, [imageUri]);
}
