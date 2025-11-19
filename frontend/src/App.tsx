import { useState } from "react";
import "./App.css";
import { ImageUpload } from "./ImageUpload";
import { Canvas } from "./Canvas";

function App() {
  const [imageUri, setImageUri] = useState<string>();

  return (
    <>
      <h1>Bingo</h1>
      <div className="card">
        <ImageUpload setImageUri={setImageUri} />
      </div>
      {imageUri && <Canvas imageUri={imageUri} />}
    </>
  );
}

export default App;
