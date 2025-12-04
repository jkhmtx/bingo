import { useEffect, useState } from "react";

type UseImageMemoProps = {
	imageUri: string | undefined;
};

export function useImageMemo({ imageUri }: UseImageMemoProps) {
	const [image, setImage] = useState<HTMLImageElement>();

	useEffect(() => {
		if (!imageUri) {
			return;
		}

		const image = new Image();

		image.src = imageUri;

		image.onload = () => {
			setImage(image);
		};
	}, [imageUri]);

	return image;
}
