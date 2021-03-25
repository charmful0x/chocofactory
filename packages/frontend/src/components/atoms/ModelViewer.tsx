import React, { Suspense } from "react";
import { Canvas, useLoader } from "react-three-fiber";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

export interface ModelViewerProps {
  src: string;
}

const LoadModel: React.FC<ModelViewerProps> = ({ src }) => {
  const gltf = useLoader(GLTFLoader, src);
  return <primitive object={gltf.scene} dispose={null} />;
};

export const ModelViewer: React.FC<ModelViewerProps> = ({ src }) => {
  return (
    <div className="rounded-md h-full object-cover mx-auto">
      <Canvas>
        <Suspense fallback={null}>
          <LoadModel src={src} />
        </Suspense>
      </Canvas>
    </div>
  );
};
