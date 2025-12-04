import { useRef } from "react";

type ImageUploadProps = {
	setImageUri: (file: string) => void;
};

export function ImageUpload({ setImageUri }: ImageUploadProps) {
	const ref = useRef<HTMLInputElement | null>(null);

	return (
		<div className="image-upload">
			<button
				type="button"
				onClick={() => {
					ref.current?.click();
				}}
			>
				Choose a background
			</button>
			<input
				ref={ref}
				type="file"
				alt="Background Image"
				name="background"
				title="hihihi"
				accept="image/png, image/jpeg"
				onChange={(e) => {
					const file = e.target.files?.[0];
					if (!file) {
						return;
					}

					const reader = new FileReader();

					reader.onload = (e) => {
						if (!e.target || typeof e.target.result !== "string") {
							return;
						}

						setImageUri(e.target.result);
					};

					reader.readAsDataURL(file);
				}}
			/>
		</div>
	);
}
