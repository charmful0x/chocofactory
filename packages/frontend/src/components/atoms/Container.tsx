import React from "react";

export interface ContainerProps {
  children: React.ReactNode;
}

export const Container: React.FC<ContainerProps> = ({ children }) => {
  return <div className={"container mx-auto flex-grow"}>{children}</div>;
};
