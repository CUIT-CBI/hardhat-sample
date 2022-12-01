// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    struct NFTOrder{
        address owner;
        uint256 tokenId;
    }

    NFTOrder[] nfts;
    mapping(uint256 => NFTOrder) private idOfNFTOrder;
    mapping(uint256 => uint256) private idToNFTIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        //TODO
        require(account != address(0), "The address cannot be zero");

        NFTOrder memory nftorder = NFTOrder({
            owner:account,
            tokenId:tokenId
        });
        nfts.push(nftorder);

        idOfNFTOrder[tokenId] = nftorder;
        idToNFTIndex[tokenId] = nfts.length-1;

        _mint(account, tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO用户只能燃烧自己的NFT
        address _owner = idOfNFTOrder[tokenId].owner;
        require(msg.sender == _owner, "You don't have permission");
        require(nfts.length >= 1, "Array out of bounds");

        //ERC721.sol
        _burn(tokenId);

        nfts[idToNFTIndex[tokenId]] = nfts[nfts.length - 1];
        //nfts[nfts.[nfts.length - 1]] = nfts.length - 1;
        //nfts.[nfts.length - 1]
        //初值
        delete idToNFTIndex[tokenId];
        delete idOfNFTOrder[tokenId];
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return nfts.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(owner !=address(0), "");
        //只有用户自己能查自己的
        if (owner == nfts[index].owner){
            return nfts[index].tokenId; 
        }else{
            revert("You don't have permission");
        }
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return nfts[index].tokenId;
    }
}
