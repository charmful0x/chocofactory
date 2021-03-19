import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import { RecoilRoot } from "recoil";
import { AtomsRootLoader } from "./components/utils/atoms";
import Contract from "./pages/_chainId/_contractAddress";
import NFT from "./pages/_chainId/_contractAddress/_tokenId";
import CreateNFTContract from "./pages/create-nft-contract";
import Home from "./pages/index";
import Mypage from "./pages/mypage";

const App: React.FC = () => {
  return (
    <>
      <RecoilRoot>
        <AtomsRootLoader>
          <Router>
            <Switch>
              <Route path="/" exact>
                <Home />
              </Route>
              <Route path="/mypage" exact>
                <Mypage />
              </Route>
              <Route path="/create-nft-contract" exact>
                <CreateNFTContract />
              </Route>
              <Route path="/:chainId/:nftContractAddress" exact>
                <Contract />
              </Route>
              <Route path="/:chainId/:nftContractAddress/:tokenId" exact>
                <NFT />
              </Route>
            </Switch>
          </Router>
        </AtomsRootLoader>
      </RecoilRoot>
    </>
  );
};

export default App;
