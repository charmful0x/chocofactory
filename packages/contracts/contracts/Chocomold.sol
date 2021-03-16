// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/IPFS.sol";

contract Chocomold is AccessControlEnumerable, Initializable, ERC721, ERC721Burnable, IPFS {
    bytes32 constant MAINTAINER_ROLE = keccak256("MAINTAINER_ROLE");

    mapping(uint256 => bytes32) public ipfsHashes;

    string private name_;
    string private symbol_;

    // this is intentionally set as constant value with hard coding
    // because if you set this as initialize parameter, user needs to pay more gas cost
    string public constant defaultBaseURI = "http://localhost:5001/chocofactory-prod/asia-northeast1/metadata/";
    string public customBaseURI;

    // this is template contract
    // so original contract is created with fixed null value
    constructor() ERC721("", "") {
        initialize("", "", address(0x0));
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        address _owner
    ) public initializer {
        name_ = _name;
        symbol_ = _symbol;
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(MAINTAINER_ROLE, _owner);
    }

    function validateIsMaintainer(address _maintainer) internal view {
        require(hasRole(MAINTAINER_ROLE, _maintainer), "must have maintainer role");
    }

    modifier onlyMaintainer() {
        validateIsMaintainer(msg.sender);
        _;
    }

    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(AccessControlEnumerable, ERC721)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }

    function name() public view override returns (string memory) {
        return name_;
    }

    function symbol() public view override returns (string memory) {
        return symbol_;
    }

    function _baseURI() internal view override returns (string memory) {
        if (bytes(customBaseURI).length > 0) {
            return customBaseURI;
        } else {
            return defaultBaseURI;
        }
    }

    function setCustomBaseURI(string memory _customBaseURI) public onlyMaintainer {
        customBaseURI = _customBaseURI;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "token must exist");
        bytes32 ipfsHash = ipfsHashes[_tokenId];
        if (abi.encodePacked(ipfsHash).length > 0) {
            return string(_addIpfsBaseUrlPrefix(_bytesToBase58(_addSha256FunctionCodePrefix(ipfsHashes[_tokenId]))));
        } else {
            return super.tokenURI(_tokenId);
        }
    }

    function _setIpfsHash(uint256 _tokenId, bytes32 _ipfsHash) internal {
        ipfsHashes[_tokenId] = _ipfsHash;
    }

    function setIpfsHash(uint256 _tokenId, bytes32 _ipfsHash) public onlyMaintainer {
        _setIpfsHash(_tokenId, _ipfsHash);
    }

    function setIpfsHash(uint256[] memory _tokenIdList, bytes32[] memory _ipfsHashList) public onlyMaintainer {
        for (uint256 i = 0; i < _tokenIdList.length; i++) {
            _setIpfsHash(_tokenIdList[i], _ipfsHashList[i]);
        }
    }

    function mint(address _to, uint256 _tokenId) public onlyMaintainer {
        _mint(_to, _tokenId);
    }

    function _mint(
        address _to,
        uint256 _tokenId,
        bytes32 _ipfsHash
    ) internal {
        _mint(_to, _tokenId);
        _setIpfsHash(_tokenId, _ipfsHash);
    }

    function mint(address _to, uint256[] memory _tokenIdList) public onlyMaintainer {
        for (uint256 i = 0; i < _tokenIdList.length; i++) {
            _mint(_to, _tokenIdList[i]);
        }
    }

    function mint(address[] memory _toList, uint256[] memory _tokenIdList) public onlyMaintainer {
        for (uint256 i = 0; i < _tokenIdList.length; i++) {
            _mint(_toList[i], _tokenIdList[i]);
        }
    }

    function mint(
        address _to,
        uint256 _tokenId,
        bytes32 _ipfsHash
    ) public onlyMaintainer {
        _mint(_to, _tokenId, _ipfsHash);
    }

    function mint(
        address _to,
        uint256[] memory _tokenIdList,
        bytes32[] memory _ipfsHashList
    ) public onlyMaintainer {
        for (uint256 i = 0; i < _tokenIdList.length; i++) {
            _mint(_to, _tokenIdList[i], _ipfsHashList[i]);
        }
    }

    function mint(
        address[] memory _toList,
        uint256[] memory _tokenIdList,
        bytes32[] memory _ipfsHashList
    ) public onlyMaintainer {
        for (uint256 i = 0; i < _tokenIdList.length; i++) {
            _mint(_toList[i], _tokenIdList[i], _ipfsHashList[i]);
        }
    }

    function _burn(uint256 _tokenId) internal virtual override {
        super._burn(_tokenId);
        if (bytes(abi.encodePacked(ipfsHashes[_tokenId])).length > 0) {
            delete ipfsHashes[_tokenId];
        }
    }
}
