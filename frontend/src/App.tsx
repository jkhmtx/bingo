import { useState } from "react";
import "./App.css";
import { ImageUpload } from "./ImageUpload";
import { Canvas } from "./Canvas";

function App() {
  const [imageUri, setImageUri] = useState<string>();

  return (
    <>
      <ImageUpload setImageUri={setImageUri} />
      {imageUri && <Canvas imageUri={imageUri} />}
    </>
  );
}

export default App;
