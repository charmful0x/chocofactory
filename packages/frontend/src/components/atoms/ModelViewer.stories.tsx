import React from "react";
import { ModelViewer, ModelViewerProps } from "./ModelViewer";

const args: ModelViewerProps = {
  src: "https://ipfs.io/ipfs/QmUygzzHa1ki7csZg9imYP8wxu5Xj91z1dLKGanwzs3ZGS/nft.glb",
};

export default {
  title: "Atoms/ModelViewer",
  component: ModelViewer,
  args,
};

export const Control: React.FC<ModelViewerProps> = (props) => <ModelViewer {...props} />;
