type ImageUploadProps = {
  setImageUri: (file: string) => void;
};

export function ImageUpload({ setImageUri }: ImageUploadProps) {
  return (
    <>
      <label htmlFor="background">Choose a profile picture:</label>

      <input
        type="file"
        alt="Background Image"
        name="background"
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
    </>
  );
}
