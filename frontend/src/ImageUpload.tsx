type ImageUploadProps = {
  imageUri: string;
  setImageUri: (file: string) => void;
};

export function ImageUpload({ imageUri, setImageUri }: ImageUploadProps) {
  return (
    <>
      <label htmlFor="background">Choose a profile picture:</label>

      <input
        type="file"
        alt="Background Image"
        name="background"
        accept="image/png, image/jpeg"
        onSubmit={console.log}
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
    </>
  );
}
