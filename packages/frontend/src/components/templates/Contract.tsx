import React from "react";

import { NFTContract, Metadata } from "../../types";
import { Container } from "../atoms/Container";
import { Main } from "../atoms/Main";
import { AuthGuard } from "../molecules/AuthGuard";
import { Contract } from "../organisms/Contract";
import { Footer } from "../organisms/Footer";
import { Header } from "../organisms/Header";

export interface ContractTemplateProps {
  nftContract?: NFTContract;
  metadataList: Metadata[];
}

export const ContractTemplate: React.FC<ContractTemplateProps> = ({ nftContract, metadataList }) => {
  return (
    <Main>
      <Header />
      <Container>
        <AuthGuard>
          <Contract nftContract={nftContract} metadataList={metadataList} />
        </AuthGuard>
      </Container>
      <Footer />
    </Main>
  );
};
